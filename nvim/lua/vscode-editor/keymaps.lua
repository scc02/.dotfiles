local map = require "util.map"

-- -- options设置
vim.opt['clipboard'] = 'unnamedplus'
vim.g.clipboard = vim.g.vscode_clipboard

map('n', 'L', '$')
map('v', 'L', "$")
map('n', 'H', '^')
map('v', 'H', "^")
-- map('n', ";", ":")
map('n', '{', "{zz")
map('n', '}', "}zz")
map('n', "<BS>", ':noh<CR>')
-- map('n', ";", ":")
map('i', '<C-d>', '<Esc>yypi')
-- map('i', '<C-o>', '<Esc>ddO')

map('n', '[[', "<Cmd>call search('[([{<]')<CR>")
map('n', 'gd', function()
  require('vscode').action('editor.action.revealDefinition')
end)

-- 前进光标记录newer
-- map('n', "si", "<C-i>")
-- 后退光标记录older
-- map('n', "so", "<C-o>")
--ciw不会yank改变的单词
map('n', 'c', '"_c')
map('x', 'c', '"_c')
-- map('n', 'C', '"_c')
-- 覆盖选中的部门 不会yank
map('v', 'p', '"_dP')
map('n', 'p', "p`]")

map('n', '<tab>', "<Cmd>call VSCodeNotify('workbench.action.nextEditorInGroup')<CR>")
map('n', '<S-tab>', "<Cmd>call VSCodeNotify('workbench.action.previousEditorInGroup')<CR>")

map('n', 'sv', "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>")
map('n', 'ss', "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>")
map('n', '<leader>o', "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>")
map('n', 'co', "<Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>")

-- map('n', 'gr', "<Cmd>call VSCodeNotify('references-view.findReference')<CR>")
map('n', '[d', "<Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>")
map('n', ']d', "<Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>")
map('n', '<leader>rn', "<Cmd>call VSCodeNotify('editor.action.rename')<CR>")

map('n', 'u', "<Cmd>call VSCodeNotify('undo')<CR>")
map('n', '<C-r>', "<Cmd>call VSCodeNotify('redo')<CR>")

-- map('n', 'za', "<cmd>call VSCodeNotify('editor.toggleFold')<CR>")

-- map('n', 'sh', "<cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>")
-- map('n', 'sl', "<cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>")
-- map('n', 'sk', "<cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>")
-- map('n', 'sj', "<cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>")

-- --获取相对路径 alf似乎无法生效
-- map('n','<M-f>',function ()
--     -- require('vscode').action('workbench.action.copyRelativeFilePath')
--   require('vscode').action('copyRelativeFilePath')
-- end)

-- --debug
-- map('n', '<leader>d', "<cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>")
-- -- 注释
-- map('x', 'gc', '<Plug>VSCodeCommentary')
-- map('n', 'gc', '<Plug>VSCodeCommentary')
-- map('o', 'gc', '<Plug>VSCodeCommentary')
-- map('n', 'gcc', '<Plug>VSCodeCommentaryLine')

-- --文件树相关
-- map('n', '<leader>fc', "<cmd>call VSCodeNotify('workbench.files.action.collapseExplorerFolders')<CR>")
map('n', '<leader>e', "<Cmd>call VSCodeNotify('revealInExplorer')<CR>")

-- --surround
-- map('n', "<leader>'", '<Plug>Ysurroundiw\""')
-- map('n', '<leader>[', '<Plug>Ysurroundiw]"')
-- map('n', '<leader>{', '<Plug>Ysurroundiw{"')
-- map('n', '<leader>(', '<Plug>Ysurroundiw("')
-- --git相关
-- map('n', '<leader>gfh', "<cmd>call VSCodeNotify('gitlens.diffWithPrevious')<cr>")
-- map('n', ']c', "<cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>")
-- map('n', '[c', "<cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>")
-- map('n', '<leader>gp', "<cmd>call VSCodeNotify('git.push')<CR>")
-- map('n', '<leader>gc', "<cmd>call VSCodeNotify('git.commit')<CR>")
-- map('n', '<leader>hr', "<cmd>call VSCodeNotify('git.revertSelectedRanges')<CR>")

-- -- 跳转也能加到jumplist
-- vim.cmd [[
--   nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
--   nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'
-- ]]


-- --bookmarks
-- map('n', 'mk', "<cmd>call VSCodeNotify('bookmarks.toggleLabeled')<CR>")
-- map('n', 'ma', "<cmd>call VSCodeNotify('bookmarks.listFromAllFiles')<CR>")
-- map('n', 'md', "<cmd>call VSCodeNotify('bookmarks.clear')<CR>")
--

map('n', '<leader>l', function()
  require('vscode').action('editor.action.showHover')
end)

map('n', '<leader>.', function()
  require('vscode').action('editor.action.quickFix')
end)

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    require('vscode').action('editor.cpp.disableenabled')
  end
});
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    require('vscode').action('editor.action.enableCppGlobally')
  end
});

map('n', 'za', function()
  require('vscode').action('editor.toggleFold')
end)
map('n', ',a', function()
  require('vscode').action('editor.toggleFold')
end)
