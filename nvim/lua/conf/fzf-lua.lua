local actions = require("fzf-lua").actions
local map = require "util.map"

-- 封装功能函数
local function search_word_with_args()
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
end

local function search_two_words()
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
end

local function search_references()
  local fzf = require("fzf-lua")

  -- 检查 LSP 是否可用
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("没有活跃的 LSP 服务器", vim.log.levels.ERROR)
    return
  end

  -- 获取当前光标下符号的引用（不包含声明）
  vim.lsp.buf.references(nil, {
    includeDeclaration = false,
    on_list = function(options)
      local paths_set = {}
      local paths = {}

      -- 从 LSP 返回的 items 中提取文件名
      for _, item in ipairs(options.items) do
        local filename = item.filename
        if filename and not paths_set[filename] then
          paths_set[filename] = true
          table.insert(paths, filename)
        end
      end

      if #paths == 0 then
        vim.notify("没有找到引用文件", vim.log.levels.WARN)
        return
      end

      -- 使用 fzf.grep 限制在指定文件中搜索
      fzf.grep({
        prompt = "Search in Files> ",
        search_paths = paths,  -- 限制在这些文件中搜索
        rg_opts = "--column --line-number --no-heading --color=always --smart-case",
      })
    end,
  })
end

-- 映射快捷键
map('n', ',f', ":FzfLua files<cr>", { desc = "Find files" })
map('n', ',w', ":FzfLua grep<cr>", { desc = "Live grep" })
map('n', ',o', ":FzfLua oldfiles<CR>", { desc = "Recent files" })
map('n', '<space>.', ":FzfLua lsp_code_actions<CR>", { desc = "Code actions" })
map('n', '<leader>fg', ":FzfLua git_status<CR>", { desc = "Git status" })
map('n', '<leader>fl', ":FzfLua<CR>", { desc = "FzfLua menu" })
map('n', '<leader>fm', ":FzfLua grep_cword<CR>", { desc = "Grep current word" })
map('n', '<leader>fe', search_word_with_args, { desc = "Search word with args" })
map('n', '<leader>ft', search_two_words, { desc = "Search two words" })
map('n', '<leader>fr', search_references, { desc = "Search references" })

require("fzf-lua").setup({
  fzf_opts = {
    ["--cycle"] = "", -- 启用循环
  },
  winopts = {
    preview = {
      layout = "vertical",   -- 上下分屏（"horizontal" 是左右）
      -- vertical = "down:50%", -- 向下展开，占用 50% 高度
    },
    -- on_create = function()
    --   vim.cmd [[highlight FzfCursor gui=vert]]
    --   vim.cmd [[setlocal winhighlight=TermCursor:FzfCursor]]
    -- end
  },
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
      silent = true,
      winopts = {
        row = 1.0,     -- 1.0 表示底部（0.0 是顶部）
        col = 0.5,     -- 水平居中
        width = 0.5,   -- 宽度占满屏幕
        height = 0.15, -- 高度占屏幕的 30%
        relative = "cursor",
        backdrop = 100
      },
      prompt = '❯ ',
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
    -- 搜索所有文件，除了 node_modules 和 .git 目录，如果想要搜索node_modules，netrw里使用<leader>ff在指定目录下搜索
    rg_opts = [[--files --hidden --no-ignore --iglob '!node_modules/**' --iglob '!.git/**']],
    gitignore = false, -- 禁用 fzf-lua 默认的 gitignore 过滤
    no_header = true,
    cwd_prompt = false,
    no_header_i = true, -- 隐藏交互式帮助信息
    winopts = {
      preview = {
        hidden = "hidden", -- 默认隐藏预览
      },
    }
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
