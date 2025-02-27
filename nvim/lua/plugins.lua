local map = require "util.map"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen' }
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require('nvim-highlight-colors').setup({})
    end,
    event = 'BufEnter'
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
  -- { 'mhartington/formatter.nvim',  config = function() require('conf.formatter') end, event = 'BufEnter' },
  {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup()
    end,
    event = 'BufEnter'
  },

  {
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
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-\\>" },
    config = function() require('conf.toggleterm') end,
  },

  { "lewis6991/gitsigns.nvim", config = function() require('conf.gitsign') end,   event = 'VeryLazy' },
  { "tpope/vim-fugitive",      cmd = 'Git' },

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
        pos = 'end'
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
    event = 'InsertEnter',
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      -- use MultiCursorCursor and MultiCursorVisual to customize
      -- additional cursors appearance
      vim.cmd.hi("link", "MultiCursorCursor", "Cursor")
      vim.cmd.hi("link", "MultiCursorVisual", "Visual")

      vim.keymap.set("n", "<esc>", function()
        if mc.hasCursors() then
          mc.clearCursors()
        else
          -- default <esc> handler
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
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath 'config' .. '/snippets' } })
          end
        },
        config = function()
          require('conf.luasnip')
        end,
      }
    },
    version = "*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },
      -- appearance = {
      --   use_nvim_cmp_as_default = true,
      --   nerd_font_variant = 'mono'
      -- },
      completion = {
        list = {
          selection = {
            preselect = false
          }
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          border = 'rounded',
          draw = {
            -- padding = 1,
            -- gap = 4,
            columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind", gap = 1 } },
            components = {
              kind = {
                text = function(ctx)
                  local len = 10 - string.len(ctx.kind)
                  local space = string.rep(" ", len)
                  return ctx.kind .. space .. '[' .. ctx.source_name .. ']'
                end
              }
            },
          }
        },
        documentation = {
          window = { border = 'rounded' },
          auto_show = true,
          auto_show_delay_ms = 0,
        },
      },

      keymap = {
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = {
          function(cmp)
            local mode = vim.api.nvim_get_mode().mode
            if mode == 'c' then
              return nil
            end

            local selected_item = require('blink.cmp.completion.list').get_selected_item()
            if cmp.is_visible then
              if selected_item ~= nil then
                return cmp.accept()
              else
                return cmp.accept({ index = 1 })
              end
            end
          end,
          "fallback"
        },

        ["<Tab>"] = {
          function(cmp)
            return cmp.select_next()
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            return cmp.select_prev()
          end,
          "snippet_backward",
          "fallback",
        },
      },
      sources = {
        default = { 'snippets', 'lsp', 'path', 'buffer' },
        providers = {
          snippets = {
            min_keyword_length = 1,
            score_offset = 4,
          },
          lsp = {
            min_keyword_length = 0,
            score_offset = 3,
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            fallbacks = {},
          },
          path = {
            min_keyword_length = 0,
            score_offset = 2,
          },
          buffer = {
            min_keyword_length = 1,
            score_offset = 1,
          },
        },
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local actions = require("fzf-lua").actions
      map('n', ',f', ":FzfLua files<cr>")
      map('n', ',w', ":FzfLua grep<cr>")
      require("fzf-lua").setup({
        previewers = {
          builtin = {
            syntax_limit_b = 1024 * 100, -- 100K
            limit_b        = 1024 * 1024 * 10
          }
        },
        -- winopts = {
        --   preview = {
        --     hidden = true,
        --   }
        -- },
        files = {
          no_header = true,
          cwd_prompt = false,
          winopts = {
            preview = {
              hidden = "hidden", -- 默认隐藏
            },
          },
          -- previewer = false,
          -- no_ignore = true
        },
        grep = {
          no_header = true,
          -- no_ignore = true,
        },
        keymap = {
          builtin = {
            ["<a-p>"] = "toggle-preview",
          },
          fzf = {
            ["alt-p"]  = "toggle-preview",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
          }
        },
        actions = {
          files = {
            ["alt-i"] = actions.toggle_ignore,
            ["alt-o"] = actions.toggle_hidden,
            ["enter"] = actions.file_edit_or_qf,
          }
        }
      })
    end
  },

  --[[ {
    'hrsh7th/nvim-cmp',
    config = function()
      require('conf.cmp')
    end,
    event = { 'InsertEnter', 'CmdlineEnter' },
    -- event = { 'BufRead' },
    dependencies = {
      { "onsails/lspkind.nvim" },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.3.0",
        build = "make install_jsregexp",
        config = function()
          require('conf.luasnip')
        end
      },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
    }
  }, ]]

}, {
  defaults = {
    lazy = false
  }
})
