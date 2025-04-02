local actions = require("fzf-lua").actions
local map = require "util.map"
map('n', ',f', ":FzfLua files<cr>")
map('n', ',w', ":FzfLua grep<cr>")
map('n', ',o', ":FzfLua oldfiles<CR>")
map('n', '<space>.', ":FzfLua lsp_code_actions<CR>")
map('n', '<leader>fe', function()
  local word = vim.fn.input("Search > ")
  local len = #word
  if len ~= 0 then
    local args = vim.fn.input("Args > ")
    local arg_len = #args
    if arg_len ~= 0 then
      require("fzf-lua").live_grep({ 
        search = word,
        rg_opts = args, 
        prompt = "Grep> "
      })
    end
  end
end)

-- map('n', '<leader>fd', function()
--   local filetype = vim.bo.filetype
--   local handledPath = vim.fn['defx#get_candidate']().action__path
--   require("fzf-lua").files({
--     cwd = handledPath, -- 指定搜索目录
--     prompt = "Files in my_project> ", -- 自定义提示符
--   })
-- end) -- map('n', '<leader>fo', M.reveal_in_finder)

require("fzf-lua").setup({
  -- winopts = {
  --   on_create = function()
  --     vim.cmd [[highlight FzfCursor gui=vert]]
  --     vim.cmd [[setlocal winhighlight=TermCursor:FzfCursor]]
  --   end
  -- },
  oldfiles = {
    cwd_only = true, -- 限制只显示当前工作目录下的历史文件
    stat_file = true, -- 确保文件存在（可选）
    prompt = 'History❯ ', -- 自定义提示符（可选）
  },
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
  lsp = {
    code_actions = {
      winopts = {
        row = 1.0,    -- 1.0 表示底部（0.0 是顶部）
        col = 0.5,    -- 水平居中
        width = 0.4,  -- 宽度占满屏幕
        height = 0.2, -- 高度占屏幕的 30%
        relative = "cursor",
      },
      -- previewer = false, -- 禁用预览
    },
  },
  -- winopts = {
  --   relative = "editor", -- 相对于整个编辑器
  --   row = 1.0,     -- 1.0 表示底部（0.0 是顶部）
  --   col = 0.5,     -- 水平居中
  --   width = 1.0,   -- 宽度占满屏幕
  --   height = 0.3,  -- 高度占屏幕的 30%
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


local fzf = require("fzf-lua")

local function lsp_code_actions_bottom()
  fzf.lsp_code_actions({
    winopts = {
      relative = "cursor",
      row = 1.0,
      col = 0.5,
      width = 0.4,
      height = 0.4,
    },
    previewer = false,
  })
end

-- 绑定到命令
-- vim.api.nvim_create_user_command("LspCodeActionsBottom", lsp_code_actions_bottom, {})
-- map('n', '<space>.', lsp_code_actions_bottom)

-- Add table.join function
local function table_join(tbl, sep)
  sep = sep or " "
  local result = ""
  for i, v in ipairs(tbl) do
    if i > 1 then
      result = result .. sep
    end
    result = result .. v
  end
  return result
end
