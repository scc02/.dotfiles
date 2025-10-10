local map                  = require('util.map')
local keep_position        = require('util.keep_position')
local is_git               = require('util.is_git')
local get_listed_buf_count = require('util.util').get_listed_buf_count

map("n", "<CR>", ":write!<CR>", {})

-- map('n', 'n', 'nzzzv')
-- map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z:delmarks z<cr>')
map('n', "<C-d>", '<C-d>zz')
map('n', "<C-u>", '<C-u>zz')
-- map('n', '<A-z>', 'u')

-- 使用 *的时候不要自动跳到下一个
map('n', '*', "*``")

-- 为了让c-i映射生效 配合kitty里的配置
map('n', '<C-i>', '<C-i>')

-- map('n', ',w', ':w<CR>', { silent = true })
map('n', ',q', ':q<CR>', { silent = true })
map('n', 'gq', ":q!<CR>")
-- map('n', '<cr>', '"_ciw')

-- 宏
-- map('n', 'Q', 'q')
-- map('n', 'q', '<Nop>')

map('n',',,', 'u')

-- map('n', '<C-r>', function()
--   keep_position.stay_position(function()
--     vim.cmd('redo')
--   end)
-- end)

-- map('n', ',r', ":LspRestart<CR>")

map('n', 'g;', 'g;')

map('n', 'mt', '%')
map('v', 'mt', '%')

map('n', 'yw', 'yiw')
map('n', 'cw', '"_ciw')
map('n', "<leader>w", ":/ \\<\\><Left><Left>", { silent = false })
--[[ map('n', '<A-/>', function()
  local word = vim.fn.input("Search > ")
  if word ~= nil and #word ~= 0 then
    vim.fn.setreg('/', word)
    vim.cmd('set hlsearch')
    vim.cmd('normal n')
  end
end) ]]
map('n', ',s', function()
  local word = vim.fn.input("搜索文字 > ")
  if word == nil or #word == 0 then
    -- 如果输入为空，清除搜索高亮并退出
    vim.cmd('nohlsearch')
    return
  end

  -- 转义输入文字以进行字面搜索
  local escaped_word = string.gsub(word, "\\", "\\\\")
  local literal_pattern = "\\V" .. string.gsub(escaped_word, "\n", "\\n")

  -- 设置搜索寄存器
  vim.fn.setreg('/', literal_pattern)

  -- 启用搜索高亮
  vim.cmd('set hlsearch')

  -- 尝试执行搜索，捕获可能的错误
  local success, err = pcall(function()
    vim.cmd('normal! n')
  end)

  if not success then
    -- 如果搜索失败，通知用户并清除高亮
    print("未找到模式: " .. word)
    vim.cmd('nohlsearch')
  end
end, { noremap = true, silent = false })

map('n', ',t', function()
  keep_position.stay_position(function()
    local file_path = vim.api.nvim_buf_get_name(0);
    vim.cmd [[tabnew]]
    vim.cmd('e ' .. file_path)
  end)
end)
map('n', 'tn', ':tabnext<CR>')
map('n', 'tp', ':tabprevious<CR>')
map('n', 'tc', ':tabclose<CR>')
map('n', 'to', ':tabonly<CR>')

-- map('n', '<leader>e', ':Explore <bar> :sil! /<C-R>=expand("%:t")<CR><CR> :noh<CR> <Left><Left>')
map({ 'n', 'v' }, '<leader>e', function()
  local cur_file = vim.fn.expand('%:t')
  vim.cmd.Ex()

  local starting_line = 0 -- line number of the first file
  local lines = vim.api.nvim_buf_get_lines(0, starting_line, -1, false)
  for i, file in ipairs(lines) do
    if (file == cur_file or file == cur_file .. "*") then
      vim.api.nvim_win_set_cursor(0, { starting_line + i, 0 })
      return
    end
  end
end)
map('t', '<Esc>', '<C-\\><C-n>')

local isHtmlNode = function()
  local curbuf = vim.api.nvim_get_current_buf()
  local ok, _ = pcall(vim.treesitter.get_parser, curbuf)
  if not ok then
    vim.notify('Does not find any parser for current buffer')
    return
  end
  local curnode = vim.treesitter.get_node({ bufnr = curbuf })
  if not curnode then
    return
  end
  local parent = curnode:parent()
  local ptype = parent and parent:type() or nil
  local available = { 'jsx_opening_element', 'jsx_element', 'jsx_closing_element' }
  if ptype and vim.tbl_contains(available, ptype) then
    return true
  end
  return false
end

map('n', 'mm', function()
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.')
  local l = line:sub(col, col)
  if l == '[' or l == ']' or l == '{' or l == '}' or l == '(' or l == ')' or isHtmlNode() then
    vim.cmd.normal('%')
  else
    vim.cmd.normal('*')
  end
end)

map('n', ',c', ":let @+ = fnamemodify(expand('%'), ':~:.')<CR>")

vim.keymap.set('v', ',c', function()
  -- 获取可视区间的起止行号
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  local line_info = start_line == end_line and (' 第' .. start_line .. '行') or
      (' 第' .. start_line .. '-' .. end_line .. '行')
  -- 退出可视模式（用 feedkeys 更可靠）
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  -- 设置寄存器
  vim.fn.setreg('+', path .. line_info)
end, { noremap = true, silent = true })

-- map('i', '<C-o>', '<Esc>ddO')
map('i', '<C-d>', function()
  vim.api.nvim_input('<Esc>')
  vim.cmd.normal('"0yy')
  vim.cmd.normal('"0p')
  vim.api.nvim_input('i')
end)

map('n', "<BS>", ':noh<CR>')
map('i', "<A-s>", "<Esc> :w<CR>")
map('i', "<D-s>", "<Esc> :w<CR>")
map('n', "<A-s>", ":w<CR>")
map('n', "<D-s>", ":w<CR>")
map('n', "<leader>,", ":split<bar>below<bar>resize 10<bar>term<CR>")
map('n', '[[', "<Cmd>call search('[([{<]')<CR>")

map('n', '<leader><M-j>', ':resize +3<CR>')
map('n', '<leader><M-k>', ":resize -2<CR>")
map('n', '<leader><M-h>', ":vertical resize +2<CR>")
map('n', '<leader><M-l>', ":vertical resize -2<CR>")

map('v', "<", "<gv")
map('v', ">", ">gv")


-- map('n', "sh", '<C-w>h')
-- map('n', "sj", '<C-w>j')
-- map('n', "sk", '<C-w>k')
-- map('n', "sl", '<C-w>l')

map('v', 'L', "$<Left>")
map('n', 'L', "$")

map('n', "H", "^")
map('v', "H", "^")

-- 前进光标记录newer
map('n', "si", "<C-i>")
-- 后退光标记录older
map('n', "so", "<C-o>")

map('n', "ss", ":split<CR>")
map('n', "sv", ":vsplit<CR>")

map('n', '{', '{zz')
map('n', '}', '}zz')

map('n', ';', ":", { silent = false })

--ciw不会yank改变的单词
map('n', 'c', '"_c')
map('x', 'c', '"_c')
map('n', 'C', '"_C')
map('n', 'S', '"_S')

map('n', 'p', 'p=`]')
-- 覆盖选中的部门 不会yank
map('v', 'p', '"_dP')

-- 对选中的区块执行.
map('v', '.', ':norm .<CR>')

-- 移动行
map('v', 'sj', ":m '>+1<CR>gv=gv")
map('v', 'sk', ":m '<-2<CR>gv=gv")
-- map('i', '<M-j>', '<esc>:m .+1<CR>==')
-- map('i', '<M-k>', '<esc>:m .-2<CR>==')
map('n', 'sj', ':m .+1<CR>==')
map('n', 'sk', ':m .-2<CR>==')

map('n', 'dw', 'vb"_d')
map('n', '<C-a>', 'gg<S-v>G')

-- terminal move
map('n', '<C-h>', '<C-\\><C-N><C-h>')
map('n', '<C-l>', '<C-\\><C-N><C-l>')
map('n', '<C-j>', '<C-\\><C-N><C-j>')
map('n', '<C-k>', '<C-\\><C-N><C-k>')

-- 关闭当前
map('n', ',d', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_filetype = vim.bo[current_buf].filetype
  
  -- 如果当前是特殊类型的 buffer，使用专门的关闭方式
  if current_filetype == 'netrw' then
    vim.cmd('bd')
    return
  end
  if current_filetype == 'NvimTree' then
    require('nvim-tree.api').tree.close()
    return
  end
  
  local buffers = vim.api.nvim_list_bufs()
  local valid_buffers = {}
  -- 收集所有有效的 buffer（排除当前要删除的、nvim-tree 等）
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local filetype = vim.bo[buf].filetype
      local bufname = vim.api.nvim_buf_get_name(buf)
      local buflisted = vim.bo[buf].buflisted
      -- 只选择有文件名、已列出且不是特殊类型的 buffer
      if filetype ~= 'NvimTree' and filetype ~= 'qf' and filetype ~= 'netrw' 
         and not string.find(bufname, 'fugitive') and bufname ~= '' 
         and buflisted then
        table.insert(valid_buffers, buf)
      end
    end
  end
  
  -- 如果有其他有效 buffer，先切换到它，再删除当前 buffer
  if #valid_buffers > 0 then
    -- 使用 alternate buffer (#) 作为首选，这是上一个访问的 buffer
    local alt_buf = vim.fn.bufnr('#')
    local target_buf = nil

    -- 检查 alternate buffer 是否在有效列表中
    for _, buf in ipairs(valid_buffers) do
      if buf == alt_buf then
        target_buf = alt_buf
        break
      end
    end

    -- 如果 alternate buffer 不可用，选择列表中的第一个
    if not target_buf then
      target_buf = valid_buffers[1]
    end

    vim.api.nvim_set_current_buf(target_buf)
  else
    -- 如果没有有效 buffer，创建一个新的空 buffer
    vim.cmd('enew')
  end
  
  -- 安全删除 buffer
  pcall(function()
    if vim.api.nvim_buf_is_valid(current_buf) then
      vim.cmd('bd! ' .. current_buf)
    end
  end)
  
  -- 确保焦点不在 nvim-tree 上
  local current_win_buf = vim.api.nvim_win_get_buf(0)
  if vim.bo[current_win_buf].filetype == 'NvimTree' then
    -- 如果当前焦点在 nvim-tree，寻找其他窗口
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local win_buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[win_buf].filetype ~= 'NvimTree' and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  end
end)

map('n', 'co', '<Cmd>BufferLineCloseOthers<CR>', { noremap = true, silent = true })
map('n', 'cr', '<Cmd>BufferLineCloseRight<CR>', { noremap = true, silent = true })
map('n', 'cl', '<Cmd>BufferLineCloseLeft<CR>', { noremap = true, silent = true })
-- map('n', 'c;', '<cmd>BufferCloseAllButPinned<CR>')
map('n', 'mr', '<Cmd>BufferLineMoveNext<CR>')
map('n', 'ml', '<Cmd>BufferLineMovePrev<CR>')

-- fix删除文件后切换buffer，报错E211: File "xxx" no longer available
local cleanup_invalid_buffers = function(type)
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do

    -- 检查缓冲区的 buflisted 选项
    local is_listed = vim.api.nvim_buf_get_option(buf, 'buflisted')
    if is_listed == false then
      return
    end

    if vim.api.nvim_buf_is_loaded(buf) then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname ~= "" and vim.fn.filereadable(bufname) == 0 then
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.cmd('lua vim.o.tabline = "%!v:lua.nvim_bufferline()"')
        vim.schedule(function()
          if type == 1 then
            vim.cmd([[BufferLineCycleNext]])
          else
            vim.cmd([[BufferLineCyclePrev]])
          end
        end)
      end
    end
  end
end

map({ "n", "v" }, "<TAB>", function()
  cleanup_invalid_buffers(1)
  vim.cmd([[BufferLineCycleNext]])
end)
map({ "n", "v" }, "<leader><TAB>", function()
  cleanup_invalid_buffers(2)
  vim.cmd([[BufferLineCyclePrev]])
end)
-- map('n', '<leader>;', "<cmd>BufferLineTogglePin<CR>")
-- map('n', 'c;', "<cmd>BufferLineGroupClose ungrouped<CR>")
-- map('n', '<leader>;', "<Cmd>BufferPin<CR>", { nowait = true })

-- vim-fugitive
map('n', '<leader>gp', function()
  -- 关闭当前窗口
  vim.cmd('close')
  -- 异步执行 Git push
  vim.fn.jobstart({ 'git', 'push' }, {
    on_stdout = function(_, data)
      if data then
        -- 过滤掉空行
        local non_empty_lines = {}
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(non_empty_lines, line)
          end
        end

        if #non_empty_lines > 0 then
          vim.notify('Git push output: ' .. table.concat(non_empty_lines, '\n'), vim.log.levels.INFO)
        end
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Git push completed successfully', vim.log.levels.INFO)
        vim.cmd('edit')
      else
        vim.notify('Git push failed with exit code: ' .. code, vim.log.levels.ERROR)
      end
    end,
  })

  vim.notify('Git push started in background...', vim.log.levels.INFO)
end)
map('n', ',g', function()
  if is_git.is_git_dir() then
    vim.cmd('Git')
    vim.api.nvim_feedkeys("}j", "n", true)
  end
end)
map('n', '<leader>,g', function()
  if is_git.is_git_dir() then
    vim.cmd('vertical Git')
    vim.api.nvim_feedkeys("}j", "n", true)
  end
end)
map('n', '<leader>gr', ":diffget //3<CR>")
map('n', '<leader>gl', ":diffget //2<CR>")
-- map('n', ',b', ':Git blame<CR>')
-- 定义切换 Git blame 的函数
vim.api.nvim_create_user_command('ToggleGitBlame', function()
  local blame_win = 0
  -- 遍历所有窗口
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value('filetype', { buf = buf }) == 'fugitiveblame' then
      blame_win = win
      break
    end
  end

  if blame_win > 0 then
    -- 切换到 blame 窗口并关闭
    vim.api.nvim_set_current_win(blame_win)
    vim.cmd('q')
  else
    -- 打开 Git blame
    vim.cmd('Git blame')
  end
end, {})

-- 映射 ,b 到切换函数
vim.keymap.set('n', ',b', ':ToggleGitBlame<CR>', { noremap = true, silent = true })

--diffview
map('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>')
map('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>')
map('n', '<leader>gc', "<cmd>DiffviewClose<CR>")
map('n', '<leader>gd', "<cmd>DiffviewOpen<CR>")

--surround
map('n', "<leader>'", "ysiw'", { remap = true })
map('n', '<leader>"', 'ysiw"', { remap = true })
map('n', '<leader>[', 'ysiw[', { remap = true })
map('n', '<leader>{', 'ysiw{', { remap = true })
map('n', '<leader>(', 'ysiw(', { remap = true })

--mutli cursor
map('n', '<C-LeftMouse>', "<Plug>(VM-Mouse-Cursor)")
map('n', '<C-RightMouse>', "<Plug>(VM-Mouse-Word)")
map('n', '<M-C-RightMouse>', "<Plug>(VM-Mouse-Column)")

-- 为了更好的undo
-- vim.cmd [[
--   inoremap <Space> <C-g>u<Space>
--   inoremap <C-W> <C-G>u<C-W>
--   inoremap <C-U> <C-G>u<C-U>
--   inoremap . <c-g>u.
--   inoremap : <c-g>u:
--   inoremap ! <c-g>u!
--   inoremap ? <c-g>u?
--   inoremap , <c-g>u,
--   inoremap ， <c-g>u，
--   inoremap 。 <c-g>u。
-- ]]
-- 精简版 undo break 配置
local undo_break_keys = { " ", ".", ",", "!", "?", ":", "，", "。", "！", "？" }

for _, key in ipairs(undo_break_keys) do
  vim.keymap.set("i", key, "<C-g>u" .. key, { noremap = true, silent = true })
end

-- 对删除单词和删除到行首也做撤销分隔
vim.keymap.set("i", "<C-W>", "<C-g>u<C-W>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-U>", "<C-g>u<C-U>", { noremap = true, silent = true })
vim.keymap.set("n", "o", "o<C-g>u", { noremap = true })
vim.keymap.set("n", "O", "O<C-g>u", { noremap = true })

-- map('n', ']a', ':cn<cr>')
-- map('n', '[a', ':cp<cr>')

map('n','<leader>cp',":copen<cr>")
-- 动态键位映射：根据 trouble.nvim 是否打开切换行为
local function is_trouble_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'trouble' then
      return true
    end
  end
  return false
end

map('n', ']f', function()
  if is_trouble_open() then
    require('trouble').next({ skip_groups = true, jump = true })
  else
    local ok = pcall(vim.cmd, 'cnf')
    if not ok then
      vim.cmd('cfirst')
    end
  end
end)

map('n', '[f', function()
  if is_trouble_open() then
    require('trouble').prev({ skip_groups = true, jump = true })
  else
    local ok = pcall(vim.cmd, 'cpf')
    if not ok then
      vim.cmd('clast')
    end
  end
end)

map('n', ',a', 'za')

map('n', '<C-n>', function()
  require('illuminate').goto_next_reference()
end)
map('n', '<C-p>', function()
  require('illuminate').goto_prev_reference()
end)
if vim.g.neovide then
  vim.keymap.set(
    { 'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't' },
    '<D-v>',
    function() vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
    { noremap = true, silent = true }
  )
  vim.keymap.set("n", "<D-s>", ":w<CR>")
  vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>")
  vim.g.neovide_remember_window_size = true
  -- vim.g.neovide_confirm_quit = true
  -- vim.g.neovide_no_idle = true
  vim.o.guifont = "JetBrainsMono Nerd Font:h14:w0.5"
  vim.g.neovide_cursor_vfx_particle_speed = 120.0
  -- 开启Alt和Meta按键
  vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
  -- 行高
  vim.opt.linespace = 4
  -- 滚动速度
  vim.g.neovide_scroll_animation_length = 0.1

  -- 兼容A-n https://github.com/neovide/neovide/issues/1866,导致无法输入中文
  -- vim.g.neovide_input_ime = false
  map('n', 'sn', function()
    require('illuminate').goto_next_reference()
  end)
  map('n', 'sp', function()
    require('illuminate').goto_prev_reference()
  end)
  -- 兼容A-n https://github.com/neovide/neovide/issues/1866
  -- vim.g.neovide_input_ime = false
  local function set_ime(args)
    if args.event:match("Enter$") then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end

  local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime
  })
end

-- map('n', 'sf', ':NvimTreeFindFile<CR>')
-- map('n', '<leader>q', function()
--   local is_open = require 'nvim-tree.view'.is_visible()
--   if is_open then
--     vim.cmd('NvimTreeToggle')
--   else
--     vim.cmd('NvimTreeFindFile')
--     vim.cmd [[normal zz]]
--   end
-- end)

map('n', 'q', '<Nop>')
map('n', 's', '<Nop>')
vim.keymap.set("n", "ycc", function()
  return 'yy' .. vim.v.count1 .. "gcc']p"
end, { remap = true, expr = true })

-- vim.api.nvim_set_keymap('n', '[f', ':cprevious<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', ']f', ':cnext<CR>', { noremap = true, silent = true })
