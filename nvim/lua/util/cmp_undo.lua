local M = {}

---@class CmpUndoEntry
---@field bufnr integer
---@field pre_cursor integer[]
---@field pre_view table      -- accept 前的完整 winsaveview
---@field post_cursor integer[]
---@field post_view table     -- accept 后的完整 winsaveview
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

-- buffer 关闭或重新读取后撤销树可能已变，清掉记录避免误恢复
vim.api.nvim_create_autocmd({ 'BufWipeout', 'BufReadPost' }, {
  group = vim.api.nvim_create_augroup('CmpUndoStacks', { clear = true }),
  callback = function(args)
    stacks[args.buf] = nil
  end,
})

--- 插入模式下断开 undo 块（与 blink create_undo_point 同一手法）
local function break_undo_in_insert()
  if vim.api.nvim_get_mode().mode:sub(1, 1) == 'i' then
    vim.o.undolevels = vim.o.undolevels
  end
end

local function clamp_cursor(cursor)
  local last_line = vim.fn.line('$')
  local row = math.min(math.max(cursor[1], 1), last_line)
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
  local col = math.min(math.max(cursor[2], 0), #line)
  return { row, col }
end

--- 恢复完整视图（leftcol/curswant 等），光标夹紧，topline 保证不越过光标行
local function restore_view(cursor, view)
  local pos = clamp_cursor(cursor)
  local v = vim.deepcopy(view or {})
  v.lnum, v.col, v.curswant = pos[1], pos[2], pos[2]
  v.topline = math.min(math.max(v.topline or pos[1], 1), pos[1])
  vim.fn.winrestview(v)
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

--- threshold 参数仅为向后兼容保留，已不再使用
function M.undo(_threshold)
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
    restore_view(top.pre_cursor, top.pre_view)
    table.remove(stack.accepts)
    table.insert(stack.redo, top)
    return
  end

  -- 普通 undo：跟随 nvim 原生光标（落在被撤销的修改处，同 VS Code），不清空 redo 栈
  if not pcall(vim.cmd.undo) then
    return
  end
  prune_accepts(stack)
end

--- threshold 参数仅为向后兼容保留，已不再使用
function M.redo(_threshold)
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = get_stack(bufnr)
  local top = stack.redo[#stack.redo]
  local seq = vim.fn.undotree().seq_cur

  -- 对齐 VS Code：redo 后光标停在补全正文，而不是 import
  if top and top.bufnr == bufnr and top.seq_before ~= nil and seq == top.seq_before then
    if not pcall(vim.cmd.redo) then
      return
    end
    restore_view(top.post_cursor, top.post_view)
    table.remove(stack.redo)
    table.insert(stack.accepts, top)
    return
  end

  pcall(vim.cmd.redo)
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
    local pre_view = vim.fn.winsaveview()
    -- snippet 时 blink 不建 undo 点，这里统一补一个
    break_undo_in_insert()
    local seq_at_accept = vim.fn.undotree().seq_cur

    return orig(ctx, item, function()
      -- 对齐 VS Code：accept 后断开 undo 块，后续输入成为独立的一步
      break_undo_in_insert()
      local seq_after = vim.fn.undotree().seq_cur
      -- 仅在确实产生新 undo 节点时记录（避免空 accept）
      if seq_after ~= seq_at_accept then
        M.record({
          bufnr = bufnr,
          pre_cursor = { pre_cursor[1], pre_cursor[2] },
          pre_view = pre_view,
          post_cursor = vim.api.nvim_win_get_cursor(0),
          post_view = vim.fn.winsaveview(),
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
