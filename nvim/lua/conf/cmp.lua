local ok, cmp = pcall(require, 'cmp')
local luasnip = require("luasnip")
local lspkind = require('lspkind')
if not ok then
  return
end
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


 function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
   end
cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    format = lspkind.cmp_format({
      mode = 'text', -- show only symbol annotations
      menu = ({      -- showing type in menu
        nvim_lsp = "[LSP]",
        path = "[Path]",
        buffer = "[Buffer]",
        luasnip = "[LuaSnip]",
      }),
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = function(fallback)
      if cmp.visible() then
        cmp.mapping.confirm({ select = true })()
      else
        fallback()
      end
    end,

    ["<Tab>"] = cmp.mapping(function(fallback)
      local is_visible = vim.api.nvim_call_function("codeium#GetStatusString", {})
      if trim(is_visible) ~= '*' then
        vim.api.nvim_input(vim.fn['codeium#Accept']())
      elseif cmp.visible() then
      -- if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" })
  }),
  sources = cmp.config.sources({
    {
      name = 'luasnip',
      option = { use_show_condition = true },
      entry_filter = function()
        -- 在字符串和备注里不触发snip
        local context = require("cmp.config.context")
        local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
        local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")

        --   Returning `true` will keep the entry, while returning `false` will remove it.
        return not string_ctx and not comment_ctx
      end,
    },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'lazydev', group_index = 0 }
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      }
    },
  }),
  comparators = {
    cmp.config.compare.offset,
    cmp.config.compare.exact,
    cmp.config.compare.recently_used,
  }
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = function()
    end,
    ['<C-p>'] = function()
    end,
  }),
  sources = { {
    name = 'buffer'
  } }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline({
    ['<C-n>'] = function()
    end,
    ['<C-p>'] = function()
    end,
  }),
  sources = cmp.config.sources({ {
    name = 'path'
  } }, { {
    name = 'cmdline'
  } })
})
