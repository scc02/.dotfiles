local nvim_lsp = require('lspconfig')
local util = require 'lspconfig.util'
local map = require('util.map')
local capabilities = require('blink.cmp').get_lsp_capabilities()
require 'lsp-conf.tsserver'.init(capabilities)
local servers = { 'html', 'cssls', 'tailwindcss', 'jsonls', 'rust_analyzer', 'lua_ls', 'eslint' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    single_file_support = true,
  }
end

require('lspconfig').sourcekit.setup {
  cmd = { 'sourcekit-lsp' },
  capabilities = capabilities,
  filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
  root_dir = function(filename)
    -- fix expo项目主入口在ios文件夹里
    local current_dir = vim.fn.getcwd()
    local ios_dir = current_dir .. '/ios'

    if vim.fn.isdirectory(ios_dir) == 1 then
      filename = current_dir .. '/ios' -- /Users/shichencong/workplace/2025/expo/ios
    end
    -- local file = io.open("a.log", "w")
    -- file:write(filename)
    -- file:close()

    return util.root_pattern 'buildServer.json' (filename)
        or util.root_pattern('*.xcodeproj', '*.xcworkspace')(filename)
        -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
        or util.root_pattern('compile_commands.json', 'Package.swift')(filename)
        or vim.fs.dirname(vim.fs.find('.git', { path = filename, upward = true })[1])
  end,
}

nvim_lsp["tailwindCSS"].setup {
  capabilities = capabilities,
  root_dir = vim.fn.getcwd(),
  settings = {
    tailwindCSS = {
      experimental = {
        configFile = './node_modules/@dian/vite-preset-react/lib/tailwindcss.config.js'
      }
    }
  }
}

-- nvim_lsp.denols.setup {
--   root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
-- }

-- require('lspconfig').ds_pinyin_lsp.setup {
--   capabilities = capabilities,
--   filetypes = { 'typescript', 'javascript', 'typescriptreact', 'rust', 'lua', 'gitcommit', 'TelescopePrompt' },
--   init_options = {
--     db_path = "/Users/scc/lsp/dict.db3",
--     completion_on = true,
--     match_as_same_as_input = true,
--     show_symbols_only_follow_by_hanzi = true
--   },
-- }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local bufopts = { noremap = true, silent = true, buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, bufopts)
    map('n', 'gd', vim.lsp.buf.definition, bufopts)
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
  --   current_line = true,
  --   prefix = "●",
  -- },
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
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
