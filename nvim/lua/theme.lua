-- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
local u = require("catppuccin.utils.colors")
local o = require("catppuccin").options
require("catppuccin").setup {
  -- catppuccin_flavour = 'macchiato',
  custom_highlights = function(colors)
    return {
      -- BlinkCmpMenu = {
      --   bg = colors.base
      -- },
      -- BlinkCmpMenuBorder = {
      --   bg = colors.base
      -- },
      -- BlinkCmpDocBorder = {
      --   bg = colors.base
      -- },
      -- BlinkCmpDoc = {
      --   bg = colors.base
      -- },
      -- BlinkCmpDocSeparator = {
      --   bg = colors.base
      -- },
      BlinkCmpKind = { fg = colors.blue },
      BlinkCmpMenu = { fg = colors.text },
      BlinkCmpMenuBorder = { fg = colors.blue },
      BlinkCmpDocBorder = { fg = colors.blue },
      BlinkCmpSignatureHelpActiveParameter = { fg = colors.mauve },
      BlinkCmpSignatureHelpBorder = { fg = colors.blue },
      CursorLine = {
        bg = u.vary_color(
          { latte = u.lighten(colors.mantle, 1, colors.base) },
          u.darken(colors.surface0, 1.5, colors.base)
        ),
      },
      GitSignsCurrentLineBlame = {
        fg = u.darken(colors.surface1, 1.8, colors.base),
      },
      DiagnosticVirtualTextWarn = {
        bg = colors.base
        -- bg = u.vary_color(
        --   { latte = u.lighten(colors.mantle, 1, colors.base) },
        --   u.darken(colors.surface0, 1.5, colors.base)
        -- ),
      },
      DiagnosticVirtualTextError = {
        bg = colors.base
        -- bg = u.vary_color(
        --   { latte = u.lighten(colors.mantle, 1, colors.base) },
        --   u.darken(colors.surface0, 1.5, colors.base)
        -- ),
      },
      DiagnosticVirtualTextHint = {
        bg = colors.base
        -- bg = u.vary_color(
        --   { latte = u.lighten(colors.mantle, 1, colors.base) },
        --   u.darken(colors.surface0, 1.5, colors.base)
        -- ),
      },
      DiagnosticVirtualTextInfo = {
        bg = colors.base
        -- bg = u.vary_color(
        --   { latte = u.lighten(colors.mantle, 1, colors.base) },
        --   u.darken(colors.surface0, 1.5, colors.base)
        -- ),
      },
    }
  end,
  compile = {
    enabled = true,
    path = vim.fn.stdpath "cache" .. "/catppuccin"
  },
  -- transparent_background = true
}

vim.cmd.colorscheme "catppuccin"

