---@diagnostic disable: missing-fields
vim.opt.termguicolors = true
require("bufferline").setup {
  highlights = require("catppuccin.groups.integrations.bufferline").get_theme(),
  options = {
    close_icon = 'x',
    buffer_close_icon = 'x',
    show_duplicate_prefix = true,
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' }
    },
    offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
    indicator = {
      -- icon = '▎',         -- this should be omitted if indicator style is not 'icon'
      style = 'none',
    },
    separator_style = "slant",
    custom_filter = function(buf_number, buf_numbers)
      local buf_name = vim.fn.bufname(buf_number)
      if string.find(buf_name, 'fugitive') then
        return false
      end

      -- session刚打开的buffer 没有load 也会存在没filetype的情况，所以需要加上有无name的判断
      local filetype = vim.bo[buf_number].filetype

      if filetype == 'gitcommit' then
        return false
      end

      if filetype == '' and buf_name == '' then
        return false
      end

      if filetype == 'qf' then
        return false
      end
      return true
    end
  }
}
