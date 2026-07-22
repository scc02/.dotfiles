local M = {}

---@class CmpUndoEntry
---@field bufnr integer
---@field pre_cursor integer[]
---@field pre_topline integer
---@field post_cursor integer[]
---@field seq_before integer|nil  -- 在 undo 落地后回填，供 redo 对齐
---@field seq_after integer

--- bufnr -> { accepts: CmpUndoEntry[], redo: CmpUndoEntry[] }
local stacks = {}

local function get_stack(bufnr)
  local stack = stacks[bufnr]
  if not stack then
    stack = { accepts = {}, redo = {} }
    stacks[bufnr] = stack
  end
  return stack
end

local function clamp_cursor(cursor)
  local last_line = vim.fn.line('$')
  local row = math.min(math.max(cursor[1], 1), last_line)
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
  local col = math.min(math.max(cursor[2], 0), #line)
  return { row, col }
end

local function restore_view(cursor, topline)
  local pos = clamp_cursor(cursor)
  local max_topline = math.max(1, pos[1])
  local resolved_topline = math.min(math.max(topline or pos[1], 1), max_topline)
  vim.fn.winrestview({
    lnum = pos[1],
    col = pos[2],
    topline = resolved_topline,
  })
end

--- 无记点时的兜底：光标大幅跳转则按行数差拉回
local function fallback_undo_jump(view, lines_before, threshold)
  local new_lnum = vim.api.nvim_win_get_cursor(0)[1]
  if math.abs(new_lnum - view.lnum) < threshold then
    return
  end
  local lines_after = vim.fn.line('$')
  local line_delta = lines_before - lines_after
  view.lnum = math.min(math.max(1, view.lnum - line_delta), lines_after)
  vim.fn.winrestview(view)
end

local function fallback_redo_jump(view, lines_before, threshold)
  local new_lnum = vim.api.nvim_win_get_cursor(0)[1]
  if math.abs(new_lnum - view.lnum) < threshold then
    return
  end
  local lines_after = vim.fn.line('$')
  local line_delta = lines_after - lines_before
  view.lnum = math.min(math.max(1, view.lnum + line_delta), lines_after)
  vim.fn.winrestview(view)
end

local function prune_accepts(stack)
  local seq = vim.fn.undotree().seq_cur
  while #stack.accepts > 0 and stack.accepts[#stack.accepts].seq_after > seq do
    table.remove(stack.accepts)
  end
end

function M.record(entry)
  local stack = get_stack(entry.bufnr)
  stack.redo = {}
  table.insert(stack.accepts, entry)
end

function M.undo(threshold)
  threshold = threshold or 5
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = get_stack(bufnr)
  local top = stack.accepts[#stack.accepts]
  local seq = vim.fn.undotree().seq_cur

  -- 对齐 VS Code：撤销「接受补全」时回到 accept 前光标
  if top and top.bufnr == bufnr and seq == top.seq_after then
    if not pcall(vim.cmd.undo) then
      return
    end
    top.seq_before = vim.fn.undotree().seq_cur
    restore_view(top.pre_cursor, top.pre_topline)
    table.remove(stack.accepts)
    table.insert(stack.redo, top)
    return
  end

  local view = vim.fn.winsaveview()
  local lines_before = vim.fn.line('$')
  if not pcall(vim.cmd.undo) then
    return
  end
  prune_accepts(stack)
  stack.redo = {}
  fallback_undo_jump(view, lines_before, threshold)
end

function M.redo(threshold)
  threshold = threshold or 5
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = get_stack(bufnr)
  local top = stack.redo[#stack.redo]
  local seq = vim.fn.undotree().seq_cur

  -- 对齐 VS Code：redo 后光标停在补全正文，而不是 import
  if top and top.bufnr == bufnr and top.seq_before ~= nil and seq == top.seq_before then
    if not pcall(vim.cmd.redo) then
      return
    end
    restore_view(top.post_cursor, top.pre_topline)
    table.remove(stack.redo)
    table.insert(stack.accepts, top)
    return
  end

  local view = vim.fn.winsaveview()
  local lines_before = vim.fn.line('$')
  if not pcall(vim.cmd.redo) then
    return
  end
  fallback_redo_jump(view, lines_before, threshold)
end

--- 包装 blink accept：apply 前记光标，完成后记 seq_after / 补全后光标
local blink_hooked = false

function M.setup_blink_hook()
  if blink_hooked then
    return
  end

  local modname = 'blink.cmp.completion.accept'
  local ok, orig = pcall(require, modname)
  if not ok or type(orig) ~= 'function' then
    return
  end

  local wrapped = function(ctx, item, callback)
    -- list.accept 已先 undo_preview，此处即「点确认前」的光标
    local bufnr = vim.api.nvim_get_current_buf()
    local pre_cursor = vim.api.nvim_win_get_cursor(0)
    local pre_topline = vim.fn.line('w0')
    local seq_at_accept = vim.fn.undotree().seq_cur

    return orig(ctx, item, function()
      local seq_after = vim.fn.undotree().seq_cur
      -- 仅在确实产生新 undo 节点时记录（避免空 accept）
      if seq_after ~= seq_at_accept then
        M.record({
          bufnr = bufnr,
          pre_cursor = { pre_cursor[1], pre_cursor[2] },
          pre_topline = pre_topline,
          post_cursor = vim.api.nvim_win_get_cursor(0),
          seq_before = nil,
          seq_after = seq_after,
        })
      end
      if callback then
        callback()
      end
    end)
  end

  package.loaded[modname] = wrapped
  blink_hooked = true
end

return M
