---@diagnostic disable-next-line: missing-fields
require 'nvim-treesitter.configs'.setup {
   yati = {
    enable = true,
    -- Disable by languages, see `Supported languages`
    disable = { "python" },

    -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
    default_lazy = true,

    -- Determine the fallback method used when we cannot calculate indent by tree-sitter
    --   "auto": fallback to vim auto indent
    --   "asis": use current indent as-is
    --   "cindent": see `:h cindent()`
    -- Or a custom function return the final indent result.
    default_fallback = "auto"
  },
  indent = {
    enable = false -- disable builtin indent module
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "g.",
      node_incremental = "g.",
      -- scope_incremental = "grc",
      -- node_decremental = "grm",
    },
  },
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 80 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  ensure_installed = {
    'css',
    'typescript',
    'tsx',
    'javascript',
    'html',
    'lua',
    'json',
    'rust'
  }
}

-- vim.treesitter.language.register('scss', 'less')
--
-- 可选：打开文件时自动展开折叠（防止 treesitter 异常时全折叠）
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   callback = function()
--     vim.cmd("normal zR")
--   end
-- })
