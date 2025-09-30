local map = require('util.map')
-- vim.cmd [[
--   augroup termOpenInsert
--     autocmd TermOpen * startinsert
--   augroup END
--
--   " no numbers in term mode
--   augroup termNoNumber
--     au TermOpen * setlocal nonumber norelativenumber nospell
--   augroup END
--
--   augroup _fold_bug_solution  " https://github.com/nvim-telescope/telescope.nvim/issues/559
--     autocmd!
--     autocmd BufRead * autocmd BufWinEnter * ++once normal! zx
--   augroup end
-- ]]
-- "设置cmp float 弹框样式
-- highlight FloatBorder guibg=#02b36
-- highlight NormalFloat guibg=#02b36
vim.cmd [[

  " 设置匹配单词高亮
  hi IlluminatedWordRead guibg=#1c4c5e gui=NONE
  hi IlluminatedWordText guibg=#1c4c5e gui=NONE
  hi IlluminatedWordWrite guibg=#1c4c5e gui=NONE

  hi! LspReferenceRead cterm=bold ctermbg=red guibg=#1c4c5e
  hi! LspReferenceText cterm=bold ctermbg=red guibg=#1c4c5e
  hi! LspReferenceWrite cterm=bold ctermbg=red guibg=#1c4c5e

  "LSP 提示改为下划线
  hi DiagnosticUnderlineWarn gui=undercurl
  hi DiagnosticUnderlineError gui=undercurl
  hi DiagnosticUnderlineInfo gui=undercurl
  hi DiagnosticUnderlineHint gui=undercurl
]]

-- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
--   callback=function ()
--     print(vim.bo.filetype)
--   end
-- })

vim.api.nvim_create_augroup("setWinbar", { clear = false })
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = 'setWinbar',
  callback = function()
    local exclude_filetype = { 'markdown','blink-cmp-menu','blink-cmp-documentation' }
    if vim.tbl_contains(exclude_filetype, vim.bo.filetype) then
      return
    end
    require("winbar").get_winbar()
  end,
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*",
--   command = "set fo-=c fo-=r fo-=o",
-- })

local function is_node_module_file()
  local current_file = vim.fn.expand('%:p')
  return string.find(current_file, 'node_modules') ~= nil
end
-- 最新版本支持lsp直接格式化
vim.api.nvim_create_augroup("formatOnSave2", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = 'formatOnSave2',
  pattern = {
    "*.less,*.css,*.html",
    "*.tsx,*.jsx", "*.ts", "*.js", "*.lua", "*.rs", "*.json"
  },
  callback = function()
    local line_count = vim.fn.line('$');
    -- 如果是node_modules 里面
    -- if line_count < 500 and vim.fn.getfsize(vim.fn.expand('%')) < 15000 then
    if is_node_module_file ~= true and line_count < 700 then
      -- vim.cmd('FormatWrite')
      -- vim.lsp.buf.format({ async = false })
      vim.lsp.buf.format { filter = function(client) return client.name == "eslint" end }
      -- pcall(vim.cmd, 'undojoin')
      -- vim.lsp.buf.format {}
      -- vim.cmd.write()
    end
  end
})


-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'fugitive',
--   callback = function()
--     map('n', "sh", '<C-w>h', { buffer = true })
--     map('n', "sj", '<C-w>j', { buffer = true })
--     map('n', "sk", '<C-w>k', { buffer = true })
--     map('n', "sl", '<C-w>l', { buffer = true })
--   end,
-- })

-- vim.api.nvim_create_augroup("hl_cursor_line", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
--   group = "hl_cursor_line",
--   callback = function()
--     vim.cmd("set cursorline")
--   end
-- })

-- vim.api.nvim_create_augroup("leaveSetCursorLine", { clear = false })
-- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--   group = 'leaveSetCursorLine',
--   callback = function()
--     local filetype = vim.bo.filetype;
--     local excluded_filetypes = { 'Trouble', 'DiffviewFileHistory', 'NvimTree', 'DiffviewFiles' }
--     if not vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
--       vim.cmd [[setlocal nocursorline]]
--     end
--   end
-- })

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { "Trouble", "defx" },
--   callback = function()
--     vim.cmd('set cursorline')
--   end,
-- })

vim.api.nvim_create_autocmd('BufRead', {
  callback = function()
    local line_count = vim.fn.line('$');
    if line_count > 500 or vim.fn.getfsize(vim.fn.expand('%')) > 102400 then
      -- if vim.fn.getfsize(vim.fn.expand('%')) > 10000 then -- 1 MB
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.foldexpr = '0'
      vim.opt_local.syntax = 'off'
    end
  end,
})

bus = {}
vim.api.nvim_create_augroup("delete_pre_buffer", { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = "delete_pre_buffer",
  callback = function()
    local exclude_filetype = { "", 'netrw', 'trouble', 'NvimTree' }
    if vim.tbl_contains(exclude_filetype, vim.bo.filetype) then
      return
    end
    if #bus == 0 then
      table.insert(bus, vim.api.nvim_get_current_buf())
    else
      -- 避免重复添加
      local cur = vim.api.nvim_get_current_buf()
      local last = bus[#bus]
      if last == cur then
        return
      end
      table.insert(bus, cur)
    end
  end
})

local function deleteBuf()
  -- 先判断是不是当前的buf 如果是则不执行操作
  -- local last_index = bus[#bus]
  -- if last_index ~= vim.api.nvim_get_current_buf() then
  vim.cmd("bd " .. table.remove(bus, #bus - 1))
  vim.cmd('lua vim.o.tabline = "%!v:lua.nvim_bufferline()"')
  -- else
  --   table.remove(bus)
  -- end
end

map('n', 'dp', function()
  -- 倒数第二个开始删除，因为倒数第一个是当前buffer
  local last_buf_num = bus[#bus - 1]
  if last_buf_num ~= nil and vim.api.nvim_buf_is_loaded(last_buf_num) then
    deleteBuf()
    -- else
    --   -- 如果已经关闭了，则继续往前找到没有关闭的buffer
    --   for i, value in ipairs(bus) do
    --     if not vim.api.nvim_buf_is_loaded(last_buf_num) then
    --       -- 说明已经关闭，则直接从bus删除此buf number
    --       table.remove(bus, i)
    --     else
    --       deleteBuf()
    --     end
    --   end
  end
end)






-- 读取message到buf
vim.g.DEBUG = false
local log = require("plenary.log").new({
  plugin = "redir",
})

local function redir_open_win(buf, vertical, stderr_p)
  local wn = stderr_p and "redir_sterr_win" or "redir_win"
  if vim.g[wn] == nil then
    local win = vim.api.nvim_open_win(buf, true, {
      -- vertical = vertical,
      vertical = true,
    })
    vim.api.nvim_create_autocmd("WinClosed", {
      pattern = { string.format("%d", win) },
      callback = function()
        vim.g[wn] = nil
      end,
    })
    vim.g[wn] = win
  else
    vim.api.nvim_win_set_buf(vim.g[wn], buf)
  end
end

local function redir_vim_command(cmd, vertical)
  vim.cmd("redir => output")
  vim.cmd("silent " .. cmd)
  vim.cmd("redir END")
  local output = vim.fn.split(vim.g.output, "\n")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, output)

  redir_open_win(buf, vertical)
end

local function redir_shell_command(cmd, lines, vertical, stderr_p)
  local shell_cmd = {
    "sh",
    "-c",
    cmd,
  }

  local stdin = nil
  if #lines ~= 0 then
    stdin = lines
  end

  local stdout_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("ft", "redir_stdout", { buf = stdout_buf })
  redir_open_win(stdout_buf, vertical)

  local stderr = nil
  if stderr_p then
    local stderr_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("ft", "redir_sterr", { buf = stderr_buf })
    redir_open_win(stderr_buf, vertical, true)
    stderr = function(err, data)
      vim.schedule_wrap(function()
        if data ~= nil then
          local output = vim.fn.split(data, "\n")
          if vim.g.DEBUG then
            log.info("stdout: " .. vim.inspect(output))
          end
          vim.api.nvim_buf_set_lines(stderr_buf, -1, -1, false, output)
        end
      end)()
    end
  end

  if vim.g.DEBUG then
    local report = string.format(
      [[lines: %s
stdin: %s
buf: %d
cmd_str: %s
shell_cmd: %s
]],
      vim.inspect(lines),
      vim.inspect(stdin),
      stdout_buf,
      cmd,
      vim.inspect(shell_cmd)
    )
    log.info(report)
  end

  vim.system(shell_cmd, {
    text = true,
    stdout = function(err, stdout)
      vim.schedule_wrap(function()
        if stdout ~= nil then
          local output = vim.fn.split(stdout, "\n")
          if vim.g.DEBUG then
            log.info("stdout: " .. vim.inspect(output))
          end
          vim.api.nvim_buf_set_lines(stdout_buf, -1, -1, false, output)
        end
      end)()
    end,
    stderr = stderr,
    stdin = stdin,
  }, function(completed)
    -- NOTE:
    -- placeholder to make call async
  end)
end

local function redir(args)
  local cmd = args.args
  local vertical = args.smods.vertical
  local stderr_p = args.bang

  if vim.g.DEBUG then
    log.info(vim.inspect(args))
  end

  if cmd:sub(1, 1) == "!" then
    local range = args.range
    local lines
    if range == 0 then
      lines = {}
    else
      local line1 = args.line1 - 1
      local line2 = args.line2
      line2 = line1 == line2 and line1 + 1 or line2
      lines = vim.api.nvim_buf_get_lines(0, line1, line2, false)
    end

    cmd = cmd:sub(2)
    redir_shell_command(cmd, lines, vertical, stderr_p)
  else
    redir_vim_command(cmd, vertical)
  end
end

vim.api.nvim_create_user_command("Redir", redir, {
  nargs = "+",
  complete = "command",
  range = true,
  bang = true,
})
map('n', ',m', ':Redir messages<cr>')
