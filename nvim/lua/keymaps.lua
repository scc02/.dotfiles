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

map('n', ',u', function()
  keep_position.stay_position(function()
    vim.cmd [[u]]
  end)
end)

-- map('n', '<C-r>', function()
--   keep_position.stay_position(function()
--     vim.cmd('redo')
--   end)
-- end)

map('n', ',r', ":LspRestart<CR>")

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
  local word = vim.fn.input("Search Literal > ")
  if word ~= nil and #word ~= 0 then
    local escaped_word = string.gsub(word, "\\", "\\\\")
    local literal_pattern = "\\V" .. string.gsub(escaped_word, "\n", "\\n")
    vim.fn.setreg('/', literal_pattern)
    vim.cmd('set hlsearch')
    vim.cmd('normal n')
  end
end)

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
  local len = #vim.api.nvim_list_wins()
  -- local bufferLen = vim.api.nvim_exec("echo len(getbufinfo({'buflisted':1}))", true)
  local bufferLen = get_listed_buf_count()
  if (len > 1) then
    if (bufferLen == 1) then
      vim.cmd("q")
      -- 配合nvim-tree的preview
    elseif (vim.bo.bufhidden == 'delete') then
      -- local isNvimtreeOpen = require 'nvim-tree.view'.is_visible()
      -- if isNvimtreeOpen then
      --   vim.cmd('NvimTreeClose')
      --   vim.cmd("bd!")
      --   vim.cmd('NvimTreeOpen')
      -- else
      vim.cmd("bd!")
      -- end
    else
      vim.cmd("b#|bd#")
    end
  else
    vim.cmd('bd!')
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
    local buf = vim.api.nvim_get_current_buf()

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
map('n', '<leader>gp', ':Git push<CR>')
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
vim.cmd [[
  inoremap <Space> <C-g>u<Space>
  inoremap <C-W> <C-G>u<C-W>
  inoremap <C-U> <C-G>u<C-U>
  inoremap . <c-g>u.
  inoremap : <c-g>u:
  inoremap ! <c-g>u!
  inoremap ? <c-g>u?
  inoremap , <c-g>u,
  inoremap ， <c-g>u，
  inoremap 。 <c-g>u。
]]

-- map('n', ']a', ':cn<cr>')
-- map('n', '[a', ':cp<cr>')
-- map('n', ']f', ':cnf<cr>')
-- map('n', '[f', ':cpf<cr>')

map('n', ',a', 'za')

map('n', 'sn', function()
  require('illuminate').goto_next_reference()
end)
map('n', 'sp', function()
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
