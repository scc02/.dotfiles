-- Lua
local actions = require("diffview.actions")
require("diffview").setup({
  show_help_hints = false,
  keymaps = {
    disable_defaults = false,          -- Disable the default keymaps
    view = {
      ["gf"] = actions.goto_file_edit, -- Open the file in a new split in the previous tabpage
    },
    file_panel = {
    },
    file_history_panel = {
      ["gf"] = function()
        actions.goto_file_edit()
        vim.defer_fn(function()
          vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end, 0)
      end,

    },
    option_panel = {
      ["<tab>"] = actions.select_entry,
      ["q"]     = actions.close,
    },
  },
  -- file_panel = {
  --   win_config = {
  --     position = "bottom", -- 将目录面板放在屏幕下方
  --     height = 16,         -- 设置面板高度（可以根据需要调整）
  --   },
  -- },
  file_history_panel = {
    win_config = {
      height = 10
    }
  }
})

vim.opt.fillchars = {
  diff = '╱',
}

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:12',
  'algorithm:histogram',
  'linematch:200',
  'indent-heuristic',
}
