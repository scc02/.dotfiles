local nvim_lsp = require('lspconfig')


local M = {}
M.init = function(capabilities)
  nvim_lsp['ts_ls'].setup {
    capabilities = capabilities,
    root_dir = nvim_lsp.util.root_pattern("package.json"),
    single_file_support = false,
    cmd = { "typescript-language-server", "--stdio" },
    settings = {
      -- typescript = {
      --   inlayHints = {
      --     includeInlayParameterNameHints = 'all',
      --     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      --     includeInlayFunctionParameterTypeHints = true,
      --     includeInlayVariableTypeHints = true,
      --     includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      --     includeInlayPropertyDeclarationTypeHints = true,
      --     includeInlayFunctionLikeReturnTypeHints = true,
      --     includeInlayEnumMemberValueHints = true,
      --   }
      -- },
      -- javascript = {
      --   inlayHints = {
      --     includeInlayParameterNameHints = 'all',
      --     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      --     includeInlayFunctionParameterTypeHints = true,
      --     includeInlayVariableTypeHints = true,
      --     includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      --     includeInlayPropertyDeclarationTypeHints = true,
      --     includeInlayFunctionLikeReturnTypeHints = true,
      --     includeInlayEnumMemberValueHints = true,
      --   }
      -- }
    },
    init_options = {
      preferences = {
        providePrefixAndSuffixTextForRename = false,
      },
      tsserver = {
        path = '/opt/homebrew/lib/node_modules/typescript/lib/tsserver.js'
      }
    },
  }
end

return M
