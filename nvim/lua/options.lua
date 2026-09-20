local options = {
  winborder = 'rounded',
  -- -- 侧边滚动
  -- sidescrolloff = 5,
  -- -- 上下滚动
  -- scrolloff = 5,
  -- 换行
  wrap = true,
  -- 命令行高度
  cmdheight = 1,
  -- 侧边数字栏
  number = true,
  -- relativenumber = true,
  -- 复用系统剪切板
  clipboard = "unnamedplus",
  -- 只显示一个status line
  laststatus = 3,
  -- 换行自动indent
  smartindent = true,
  -- 取消复用上行的indent
  autoindent = false,
  -- expandtab的作用是把tab字符转化空格
  expandtab = true,
  -- tabstop的作用是一个tab显示多少个空格,修改显示的宽度。
  tabstop = 2,
  softtabstop = 2,
  smarttab = true,
  -- 自动缩进时,缩进长度为2
  shiftwidth = 2,
  -- 右下角不显示正在操作的命令
  showcmd = false,
  -- 同一行换行显示的时候带上indent
  breakindent = true,
  -- 重新打开文件也可以用undo
  undofile = true,
  -- 补全菜单的高度
  pumheight = 10,
  -- 自动分屏后的位置
  splitbelow = true,
  splitright = true,
  -- 关闭swapfile
  swapfile = false,
  -- 默认忽略大小写，当搜索的内容包含大写字母则改为大小写敏感 中文替换时特别卡
  ignorecase = true,
  smartcase = true,
  -- 提前开启signcolumn 避免输入时侧边栏移动
  signcolumn = "yes",
  -- 折叠代码 默认有些代码无法识别折叠 比如jsx等
  -- foldmethod = "indent",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldmethod = 'expr',
  -- 默认打开文件不折叠
  -- foldenable = false,
  -- foldlevel = 99,
  -- foldlevelstart = 99,
  -- enable mouseclicks
  mouse = 'a',
  completeopt = { "menu", "menuone", "noselect" },
  -- CursorHold触发的时间
  updatetime = 500,
  cursorline = false,
  -- 侧边数字列的宽度
  numberwidth = 1,
  timeoutlen = 500,
  -- 修改fillchar
  fillchars = { diff = '╱', vertright = ' ' },
  --响应鼠标,
  mousemoveevent = true,
  --新开window保持代码不动
  splitkeep = 'screen'
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.opt.iskeyword:append("-")
vim.opt.diffopt:append("vertical")

-- 关闭vim-mutli-cursor plugin的warning
vim.g['VM_show_warnings'] = 0
-- tpipeline闪烁
-- vim.g['tpipeline_focuslost'] = 0
-- vim.g['NERDTreeWinPos'] = 'right'

vim.cmd [[
  set formatoptions-=cro
]]
-- vim.cmd [[autocmd BufWinEnter * if line2byte(line("$") + 1) > 100000 | syntax clear | endif]]
-- vim.g.netrw_banner = 0        -- disable that anoying Netrw banner
-- vim.g.netrw_browser_split = 4 -- open in a prior window
-- vim.g.netrw_altv = 1          -- open splits to the right
-- vim.g.netrw_liststyle = 3     -- treeview

vim.g['netrw_banner'] = 0
vim.cmd([[
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide=ghregex
]])
vim.cmd [[
  hi Folded guibg=NONE guifg=NONE
]]

-- 配置显示排序
vim.g.netrw_sort_sequence = '[[\\/]$,*]'

vim.g.augment_workspace_folders = { "." }

-- Neovim 内置 treesitter 高亮（不依赖 nvim-treesitter 插件的 highlight 模块）
local treesitter_highlight_filetypes = {
  'css',
  'typescript',
  'typescriptreact',
  'javascript',
  'javascriptreact',
  'html',
  'lua',
  'json',
  'rust',
  'tsx',
  'jsx',
  'ets',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = treesitter_highlight_filetypes,
  callback = function(args)
    local max_filesize = 80 * 1024 -- 80 KB，大文件跳过高亮
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end
    pcall(vim.treesitter.start)
  end,
})

-- 鸿蒙 .ets 用 tsx parser 高亮（filetype 保持 ets，避免 ts_ls 乱报错）
vim.filetype.add({
  extension = {
    ets = 'ets',
  },
})
vim.treesitter.language.register('tsx', 'ets')

-- 恢复旧版 incremental_selection 的 g.（Nvim 0.12 内置 vim.treesitter.select）
-- 原配置：init_selection / node_incremental 都是 g.
vim.keymap.set({ 'n', 'x' }, 'g.', function()
  vim.treesitter.select('parent', vim.v.count1)
end, { desc = 'Treesitter expand node selection' })


