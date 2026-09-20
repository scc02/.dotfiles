---@diagnostic disable-next-line: missing-fields
require 'nvim-treesitter.configs'.setup {
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

-- 鸿蒙 .ets 用 tsx 高亮（filetype 保持 ets，避免 ts_ls 乱报错）
vim.filetype.add({
  extension = {
    ets = 'ets',
  },
})
vim.treesitter.language.register('tsx', 'ets')
