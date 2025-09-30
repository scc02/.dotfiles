local lspconfig = require('lspconfig')
local lspconfig_util = require 'lspconfig.util'
local util = require 'util.util'
local map = require('util.map')
local capabilities = require('blink.cmp').get_lsp_capabilities()
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local configs = require "lspconfig.configs"
-- require 'lsp-conf.tsserver'.init(capabilities)
local servers = { 'html', 'cssls', 'jsonls', 'rust_analyzer', 'lua_ls' }
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
    single_file_support = true,
  })
  vim.lsp.enable(lsp)
end

-- ESLint LSP 只在发现配置文件时启动
vim.lsp.config('eslint', {
  capabilities = capabilities,
  -- root_dir = lspconfig_util.root_pattern(
  --   '.eslintrc',
  --   '.eslintrc.js',
  --   '.eslintrc.cjs',
  --   '.eslintrc.yaml',
  --   '.eslintrc.yml',
  --   '.eslintrc.json',
  --   'eslint.config.js',
  --   'eslint.config.mjs',
  --   'eslint.config.cjs'
  -- ),
  -- settings = {
  --   packageManager = 'npm'
  -- }
})
vim.lsp.enable('eslint')
-- vim.lsp.enable('biome')

-- require('lspconfig').sourcekit.setup {
--   cmd = { 'sourcekit-lsp' },
--   capabilities = capabilities,
--   filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
--   root_dir = function(filename)
--     -- fix expo项目主入口在ios文件夹里
--     local current_dir = vim.fn.getcwd()
--     local ios_dir = current_dir .. '/ios'
--
--     if vim.fn.isdirectory(ios_dir) == 1 then
--       filename = current_dir .. '/ios' -- /Users/shichencong/workplace/2025/expo/ios
--     end
--     -- local file = io.open("a.log", "w")
--     -- file:write(filename)
--     -- file:close()
--
--     return lspconfig_util.root_pattern 'buildServer.json' (filename)
--         or lspconfig_util.root_pattern('*.xcodeproj', '*.xcworkspace')(filename)
--         -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
--         or lspconfig_util.root_pattern('compile_commands.json', 'Package.swift')(filename)
--         or vim.fs.dirname(vim.fs.find('.git', { path = filename, upward = true })[1])
--   end,
-- }

vim.lsp.config('tailwindCSS', {
  capabilities = capabilities,
  root_dir = vim.fn.getcwd(),
  settings = {
    tailwindCSS = {
      experimental = {
        configFile = (function()
          local config_path = './node_modules/@dian/vite-preset-react/lib/tailwindcss.config.js'
          if vim.fn.filereadable(config_path) == 1 then
            return config_path
          else
            return nil
          end
        end)()
      }
    }
  }
})
vim.lsp.enable('tailwindCSS')

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  root_dir = vim.fn.getcwd(),
  init_options = {
    preferences = {
      providePrefixAndSuffixTextForRename = false,
    },
  },
})
vim.lsp.enable('ts_ls')

--[[ vim.lsp.config('tsgo',{
  capabilities = capabilities,
  init_options = {
    preferences = {
      providePrefixAndSuffixTextForRename = false,
    },
  },
  default_config = {
    cmd = { "tsgo", "--lsp", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = lspconfig.util.root_pattern(
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git",
      "tsconfig.base.json"
    ),
    settings = {},
  }
})
vim.lsp.enable('tsgo') ]]

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local bufopts = { noremap = true, silent = true, buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- map('n', 'gd', vim.lsp.buf.definition, bufopts)
    map('n', 'gd', function()
      local clients = vim.lsp.get_clients({ bufnr = ev.buf })
      local is_ts_ls_attached = false
      for _, client in ipairs(clients) do
        if client.name == "ts_ls" then
          is_ts_ls_attached = true
          break
        end
      end

      if is_ts_ls_attached then
        vim.lsp.buf.definition({
          on_list = function(options)
            if options.items and #options.items > 1 then
              local filtered_result = util.filter(options.items, util.filterReactDTS)
              options.items = filtered_result
              if #options.items >= 1 then
                local item = options.items[1]
                if item.filename then
                  -- 检查当前文件是否与目标文件相同
                  local current_file = vim.api.nvim_buf_get_name(0)
                  if current_file ~= item.filename then
                    vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
                  end
                end
                vim.api.nvim_win_set_cursor(0, {item.lnum, item.col - 1})
              end
            elseif options.items and #options.items == 1 then
              local item = options.items[1]
              if item.filename then
                -- 检查当前文件是否与目标文件相同
                local current_file = vim.api.nvim_buf_get_name(0)
                if current_file ~= item.filename then
                  vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
                end
              end
              vim.api.nvim_win_set_cursor(0, {item.lnum, item.col - 1})
            else
              print("No definition found")
            end
          end,
        })
      else
        vim.lsp.buf.definition()
      end
    end, bufopts)
    map('n', 'K', vim.lsp.buf.hover, bufopts)
    map('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    -- map('n', '<space>.', vim.lsp.buf.code_action, bufopts)
    map('n', '<space>gi', '<cmd>Trouble lsp_implementations<cr>', bufopts)
    map('n', 'gr', '<cmd>Trouble lsp_references<cr>', bufopts)
    map('n', '<leader>gr', function() vim.lsp.buf.references({ includeDeclaration = false }) end, bufopts)
    map('n', '<space>o', ":lua vim.lsp.buf.format({ async = true })<CR>", bufopts)
    map('n', '<space>l', ":lua vim.diagnostic.open_float({max_width=100})<CR>")
    -- map('n', '<leader>[d', vim.diagnostic.goto_prev)
    -- map('n', '<leader>]d', vim.diagnostic.goto_next)
    map('n', '[d', function()
      local errorList = vim.diagnostic.get(0)
      local has_error = false;
      for _, value in ipairs(errorList) do
        if value.severity == 1 then
          has_error = true
          break
        end
      end
      -- 有错误的时候跳转错误，没有错误则跳转信息提示
      if has_error then
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
      else
        vim.diagnostic.jump({ count = -1, float = true })
      end
    end)
    map('n', ']d', function()
      local errorList = vim.diagnostic.get(0)
      local has_error = false;
      for _, value in ipairs(errorList) do
        if value.severity == 1 then
          has_error = true
          break
        end
      end
      if has_error then
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
      else
        vim.diagnostic.jump({ count = 1, float = true })
      end
    end)
  end,
})
-- local signs = {
--   { name = "DiagnosticSignError", text = '󰅚 ', texthl = 'DiagnosticSignError' },
--   { name = "DiagnosticSignWarn", text = '󰀪 ', texthl = 'DiagnosticSignWarn' },
--   { name = "DiagnosticSignInfo", text = '󰋽 ', texthl = 'DiagnosticSignInfo' },
--   { name = "DiagnosticSignHint", text = '󰌶 ', texthl = 'DiagnosticSignHint' },
-- }
-- for _, sign in ipairs(signs) do
--   vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.texthl })
-- end

vim.diagnostic.config({
  -- virtual_text = {
  --   -- current_line = true,
  --   prefix = "●",
  --   -- prefix = " ",
  --   severity = {
  --     min = vim.diagnostic.severity.ERROR,
  --   },
  -- },
  -- virtual_lines = false,
  -- virtual_text = {
  --   severity = {
  --     max = vim.diagnostic.severity.WARN,
  --   },
  -- },
  -- virtual_lines = {
  --   severity = {
  --     min = vim.diagnostic.severity.ERROR,
  --   },
  -- },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵 ',
    },
    -- linehl = {
    --   [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    -- },
    -- numhl = {
    --   [vim.diagnostic.severity.WARN] = 'WarningMsg',
    -- },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = true,
  }
  -- Lsp报错的提示框
  -- float = {
  --   focusable = true,
  --   style = "minimal",
  --   -- border = "rounded",
  --   source = "always",
  --   header = "",
  --   prefix = "",
  -- },
})

vim.lsp.config('ds_pinyin_lsp', {
  init_options = {
    db_path = "/Users/shichencong/lsp/dict.db3",
    show_symbols = false,
    max_suggest = 5
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "lua",
    "gitcommit"
  },
})
vim.lsp.enable('ds_pinyin_lsp')

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--
--     if client:supports_method('textDocument/documentColor') then
--       if vim.lsp.document_color ~= nil then
--         vim.lsp.document_color.enable(true, args.buf)
--       end
--     end
--   end
-- })
