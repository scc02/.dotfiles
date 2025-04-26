vim.g.mapleader = " "

if not vim.g['vscode'] then
  require('options')
  require('keymaps')
  require('plugins')
  require('autocmd')
else
  -- require('vscode.keymaps')
end
