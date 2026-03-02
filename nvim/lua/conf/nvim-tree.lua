local map       = require('util.map')

local git_icons = {
  unstaged = "",
  staged = "",
  unmerged = "",
  renamed = "➜",
  untracked = "",
  deleted = "",
  ignored = "◌"
}

map('n', ',r', ':NvimTreeFindFile<CR>')
map('n', ',e', function()
  local api = require('nvim-tree.api')
  if api.tree.is_visible() then
    api.tree.close()
  else
    vim.cmd('NvimTreeFindFile')
  end
end)
map('n', ',o', ':NvimTreeCollapse<CR>')
local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- 默认按键映射
  api.config.mappings.default_on_attach(bufnr)

  -- 自定义按键映射
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
end

require 'nvim-tree'.setup {
  on_attach = on_attach,
  view = {
    adaptive_size = true
    -- side = "right",
    -- float = {
    --   enable = true,
    --   open_win_config = {
    --     relative = 'win'
    --   }
    -- },
  },
  filters = {
    dotfiles = false,  -- 设置为 false 表示显示 dotfiles (以 . 开头的文件)
    custom = { ".git" },  -- 可选择性地排除某些文件或文件夹
    git_ignored = false,  -- 不隐藏 .gitignore 中的文件
  },
  renderer = {
    root_folder_label = false,
    icons = {
      git_placement = "after",
      modified_placement = "after",
      show = {
        folder = false,
        -- file = false,
        -- folder_arrow = false,
      },
      glyphs = {
        git = git_icons
      }
    }
  }
}

-- 当只剩下 nvim-tree 窗口时自动退出 nvim
-- vim.api.nvim_create_autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
--       vim.cmd "quit"
--     end
--   end
-- })
