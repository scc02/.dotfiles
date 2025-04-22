local actions = require("fzf-lua").actions
local map = require "util.map"
map('n', ',f', ":FzfLua files<cr>")
map('n', ',w', ":FzfLua grep<cr>")
map('n', ',o', ":FzfLua oldfiles<CR>")
map('n', '<space>.', ":FzfLua lsp_code_actions<CR>")
map('n', '<leader>fs', ":FzfLua git_status<CR>")
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
  fzf_opts = {
    ["--cycle"] = "", -- 启用循环
  },
  -- winopts = {
  --   on_create = function()
  --     vim.cmd [[highlight FzfCursor gui=vert]]
  --     vim.cmd [[setlocal winhighlight=TermCursor:FzfCursor]]
  --   end
  -- },
  oldfiles = {
    cwd_only = true, -- 限制只显示当前工作目录下的历史文件
    stat_file = true, -- 确保文件存在（可选）
    prompt = '❯ ', -- 自定义提示符（可选）
  },
  git = {
    status = {
      no_header = true
    }
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
        width = 0.5,  -- 宽度占满屏幕
        height = 0.15, -- 高度占屏幕的 30%
        relative = "cursor",
        backdrop = 100
      },
      prompt='❯ ',
      previewer = false, -- 禁用预览
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

vim.keymap.set("n", "<leader>fg", function()
  local word1 = vim.fn.input("Enter first word: ")
  if word1 == "" then return end -- 如果输入为空，则退出

  local word2 = vim.fn.input("Enter second word: ")
  if word2 == "" then return end -- 如果输入为空，则退出

  local cmd = string.format(
    "rg --hidden --iglob !.git --files-with-matches %s | xargs rg --with-filename --column --line-number --no-heading --color=always -e %s",
    vim.fn.shellescape(word1), -- 转义第一个词以防止 shell 注入
    vim.fn.shellescape(word2)  -- 转义第二个词
  )

  require("fzf-lua").fzf_exec(cmd, {
    actions = {
      -- 当用户按 Enter 选择结果时触发
      ["enter"] = function(selected, opts)
        require("fzf-lua").actions.file_edit_or_qf(selected, opts)
      end,
    },
    previewer = "builtin",
  })
end, { desc = "Live grep for two words" }) -- 键映射描述
-- require("fzf-lua").grep({ search = string.format("(?=.*%s)(?=.*%s)", 'half', 'page'), no_esc=true, rg_opts = [[--pcre2 --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]] })
