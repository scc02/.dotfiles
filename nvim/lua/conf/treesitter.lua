-- nvim-treesitter main：只负责装 parser / query
require('nvim-treesitter').setup({})

local ensure_installed = {
  'css',
  'typescript',
  'tsx',
  'javascript',
  'html',
  'lua',
  'json',
  -- 'rust',
}

-- 异步安装缺失 parser（已装则 no-op）
require('nvim-treesitter').install(ensure_installed)
