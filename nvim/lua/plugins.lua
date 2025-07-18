---@diagnostic disable: missing-fields
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local map      = require('util.map')
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone", "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('theme')
    end
  },
  { "windwp/nvim-autopairs",   config = function() require('conf.autopairs') end, event = "InsertEnter" },

  ({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
    event = "InsertEnter",
  }),
  {
    "svban/YankAssassin.nvim",
    event = 'BufEnter',
    config = function()
      require("YankAssassin").setup {
        auto_normal = true,
        auto_visual = true,
      }
    end,
  },

  {
    "folke/trouble.nvim",
    config = function() require('conf.trouble') end,
    event = 'BufEnter'
  },
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function() require('conf.diffview') end,
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen' },
    version = "4516612fe98ff56ae0415a259ff6361a89419b0a"
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client.name == 'sourcekit' then
            client.server_capabilities.colorProvider = false
          end
        end,
      })
      require('nvim-highlight-colors').setup({})
    end,
    event = 'BufEnter',
    -- cond = function()
    --   -- https://github.com/brenoprata10/nvim-highlight-colors/issues/123
    --   local cwd = vim.fn.getcwd()
    --   return not cwd:match("expo")
    -- end
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function(self, opts)
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,         -- Auto close tags
          enable_rename = true,        -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        },
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end
  },
  {
    'akinsho/git-conflict.nvim',
    tag = 'v2.1.0',
    config = function()
      require('git-conflict').setup({})
      -- vim.keymap.set('n', 'cco', ':GitConflictChooseOurs<CR>', {})
      -- vim.keymap.set('n', 'cct', ':GitConflictChooseTheirs<CR>', {})
    end,
    event = 'BufEnter'
  },

  --[[ {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('conf.telescope')
    end,
    cmd = { "Telescope" },
    -- keys = { ',f' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'trouble.nvim',
      {
        'nvim-telescope/telescope-ui-select.nvim',
        -- config = function()
        -- require("telescope").load_extension("ui-select")
        -- end
      },
    }
  }, ]]
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-\\>" },
    config = function() require('conf.toggleterm') end,
  },

  { "lewis6991/gitsigns.nvim", config = function() require('conf.gitsign') end },
  {
    "tpope/vim-fugitive",
    cmd = 'Git',
    config = function()
      require('conf.fugitive')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('conf.treesitter')
    end
  },

  {
    "numToStr/Comment.nvim",
    config = function() require('conf.comment') end,
    event = 'BufEnter',
    dependencies = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
    }
  },

  {
    'kevinhwang91/nvim-ufo',
    config = function()
      require('conf.ufo')
    end,
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup(
            {
              relculright = true,
              segments = {
                { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                { text = { "%s" },                  click = "v:lua.ScSa" },
                { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }
              }
            }
          )
        end

      }
    },
    event = 'BufEnter'
  },


  { "neovim/nvim-lspconfig", config = function() require('lsp') end },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function() require('conf.harpoon') end,
    keys = { "<C-e>" },
  },
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_use_git_branch = true,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('conf.lualine')
    end
  },
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        -- needed since it will be false when loading and mini will fail
        package.loaded["nvim-web-devicons"] = {}
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    config = function()
      require('conf.bufferline')
    end,
    after = "catppuccin"
  },
  {
    'rainbowhxch/accelerated-jk.nvim',
    config = function()
      require('accelerated-jk').setup()
      vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)', {})
      vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)', {})
    end,
    event = 'BufRead'
  },

  ({
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('treesj').setup({
        _default_keymaps = false,
      });
      vim.keymap.set('n', '<leader>j', ':TSJToggle<CR>', { silent = true })
    end,
    keys = '<leader>j'
  }),

  {
    'alexghergh/nvim-tmux-navigation',
    event = 'VeryLazy',
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup {
        disable_when_zoomed = true -- defaults to false
      }

      vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      -- vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      -- vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = 'rounded',
          height = 0.85
        }
      })
    end
  },
  {
    'j-hui/fidget.nvim',
    tag = "legacy",
    config = function()
      require "fidget".setup {}
    end
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      jump = {
        pos = 'range'
      },
      highlight = {
        backdrop = false
      },
      prompt = {
        enabled = false,
      },
      modes = {
        char = {
          enabled = false
        },
        search = {
          enabled = false
        }
      }
    },
    -- stylua: ignore
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "F", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" }
    },
  },
  {
    "RRethy/vim-illuminate",
    event = 'VeryLazy',
    config = function()
      require('illuminate').configure({
        filetypes_denylist = {
          'harpoon',
          'fugitive',
          'Trouble',
          'mason',
          'lazy',
          'netrw',
          'qf',
          'gitcommit',
          'DiffviewFiles',
          'TelescopePrompt'
        },
      })
    end
  },
  --[[ {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    branch = 'dev',
    config = function()
      require("hlchunk").setup({
        chunk = {
          delay = 0,
          enable = true,
          style = {
            { fg = "#8c98a3" },
          },
          exclude_filetypes = {
            less = true,
          },
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
        }
      })
    end
  }, ]]
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      -- library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      -- },
    },
  },
  { "Bilal2453/luvit-meta",  lazy = true }, -- optional `vim.uv` typings,
  {
    "jake-stewart/multicursor.nvim",
    event = "InsertEnter",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()
      map({ "n" }, "<leader>m", mc.toggleCursor)
      map("v", "<leader>m", mc.matchCursors)

      -- 通过匹配单词/选择来添加或跳过添加新光标
      map({ "n", "v" }, "<leader>k", function() mc.matchAddCursor(1) end)
      map({ "n", "v" }, "<leader><leader>k", function() mc.matchSkipCursor(1) end)

      -- use MultiCursorCursor and MultiCursorVisual to customize
      -- additional cursors appearance
      -- vim.cmd.hi("link", "MultiCursorCursor", "Cursor")
      -- vim.cmd.hi("link", "MultiCursorVisual", "Visual")
      --
      map("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- add cursors above/below the main cursor
      -- vim.keymap.set("n", "<up>", function() mc.addCursor("k") end)
      -- vim.keymap.set("n", "<down>", function() mc.addCursor("j") end)

      -- add a cursor and jump to the next word under cursor
      -- vim.keymap.set("n", "<c-n>", function() mc.addCursor("*") end)

      -- jump to the next word under cursor but do not add a cursor
      -- vim.keymap.set("n", "<c-s>", function() mc.skipCursor("*") end)

      -- add and remove cursors with control + left click
      vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
    end,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      -- require('bqf').setup({
      --   preview = {
      --     show_title = false,
      --   }
      -- })
    end
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        -- dependencies = {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require("luasnip.loaders.from_vscode").lazy_load()
        --   end
        -- },
        config = function()
          require('conf.luasnip')
        end,
      }
    },
    version = "*",
    opts_extend = { "sources.default" },
    config = function ()
      require("conf.blink")
    end
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    -- event = 'BufRead',
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('conf.fzf-lua')
    end
  },
  --[[ {
    "github/copilot.vim",
    config = function()
      vim.keymap.set('i', '<C-;>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
    end,
  }, ]]
  {
    'Exafunction/windsurf.vim',
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      -- vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      -- vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      -- vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },

  -- {
  --   'sontungexpt/better-diagnostic-virtual-text',
  --   config = function(_)
  --     require('better-diagnostic-virtual-text').setup({
  --       ui = {
  --         wrap_line_after = true
  --       }
  --     })
  --   end
  -- },
}, {
  defaults = {
    lazy = false
  }
})
