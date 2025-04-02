
-- 定义一个函数来删除光标所在位置的未跟踪文件夹
local function delete_untracked_dir()
  -- 获取光标所在行的内容
  local line = vim.api.nvim_get_current_line()

  -- 检查是否是未跟踪条目（以 ?? 开头）
  if not line:match("^?? ") then
    vim.notify("Not an untracked item!", vim.log.levels.WARN)
    return
  end

  -- 提取相对路径（去掉 ?? 前缀）
  local relative_path = line:gsub("^?? ", "")

  -- 获取 Git 仓库根目录
  local git_dir = vim.fn.FugitiveGitDir() -- 获取 Git 工作目录（.git 目录）
  local repo_root = vim.fn.FugitiveWorkTree() -- 获取 Git 仓库根目录

  if repo_root == "" then
    vim.notify("Not in a Git repository!", vim.log.levels.ERROR)
    return
  end

  -- 拼接绝对路径
  local path = repo_root .. "/" .. relative_path

  -- 移除路径末尾的斜杠（如果有）
  path = path:gsub("/+$", "")

  -- 检查路径是否是文件夹
  if vim.fn.isdirectory(path) ~= 1 then
    print("Debug path: " .. path)
    vim.notify("Not a directory: " .. path, vim.log.levels.WARN)
    return
  end

  -- 确认删除操作
  local choice = vim.fn.confirm("Delete untracked directory '" .. path .. "'?", "&Yes\n&No", 2)
  if choice == 1 then
    -- 执行删除命令
    vim.fn.system("rm -rf " .. vim.fn.shellescape(path))
    -- 刷新 :Gstatus 窗口
    vim.cmd("Git")
  else
    vim.notify("Deletion canceled.", vim.log.levels.INFO)
  end
end

-- 设置 autocmd 和键映射
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.keymap.set("n", "<leader>x", delete_untracked_dir, { buffer = true, desc = "Delete untracked directory under cursor" })
  end,
})

