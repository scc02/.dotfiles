-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
require("catppuccin").setup {
  -- catppuccin_flavour = 'macchiato',
  custom_highlights = function(colors)
    return {
      BlinkCmpMenu = {
        bg = colors.base
      },
      BlinkCmpMenuBorder = {
        bg = colors.base
      },
      BlinkCmpDocBorder = {
        bg = colors.base
      },
      BlinkCmpDoc = {
        bg = colors.base
      },
      BlinkCmpDocSeparator = {
        bg = colors.base
      }
    }
  end,
  compile = {
    enabled = true,
    path = vim.fn.stdpath "cache" .. "/catppuccin"
  },
  -- transparent_background = true
}

vim.cmd.colorscheme "catppuccin"
