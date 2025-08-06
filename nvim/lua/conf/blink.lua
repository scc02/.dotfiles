local blink = require('blink-cmp')
blink.setup({
  cmdline = {
    completion = {
      menu = {
        auto_show = function(ctx)
          return vim.fn.getcmdtype() == ':'
          -- enable for inputs as well, with:
          -- or vim.fn.getcmdtype() == '@'
        end,
      },
      ghost_text = { enabled = false }
    },
    keymap = {
      ["<CR>"] = { "select_and_accept", "fallback" }
    }
  },
  snippets = { preset = 'luasnip' },
  -- appearance = {
  --   use_nvim_cmp_as_default = true,
  --   nerd_font_variant = 'mono'
  -- },
  fuzzy = {
    sorts = {
      'exact',
      'score',
      'sort_text',
    },
  },
  completion = {
    list = {
      selection = {
        -- preselect = true
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
        local is_visible = vim.api.nvim_call_function("codeium#GetStatusString", {})
        if is_visible ~= '*' then
            vim.fn['codeium#Accept']()
        else
          return cmp.select_next()
        end
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
    ["<C-k>"] = { "show" },
    ["<C-j>"] = { "hide", "fallback" },
  },
  sources = {
    default = { 'snippets', 'lsp', 'path', 'buffer' },
    providers = {
      codeium = {
        name = "codeium",
        module = "blink.compat.source",
      },
      snippets = {
        min_keyword_length = 1,
        score_offset = 4,
      },
      cmdline = {
        min_keyword_length = function(ctx)
          -- when typing a command, only show when the keyword is 3 characters or longer
          if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 3 end
          return 0
        end
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

})

