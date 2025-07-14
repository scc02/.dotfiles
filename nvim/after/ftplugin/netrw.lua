local map = require('util.map')
local o = vim.opt

o.colorcolumn = nil

map('n', 'N', function()
  local file_name = vim.fn.input("File name: ")
  if file_name ~= '' then
    local curdir = vim.b.netrw_curdir
    vim.fn.writefile({}, curdir .. '/' .. file_name)
    vim.cmd('e')
    vim.fn.search('^' .. vim.fn.escape(file_name, '[]') .. '$')
  end
end, { remap = true, buffer = true })
-- new Dir
map('n', 'K', function()
  local dir_name = vim.fn.input("Directory name: ")
  if dir_name ~= '' then
    local curdir = vim.b.netrw_curdir
    local full_path = curdir .. '/' .. dir_name
    if vim.fn.mkdir(full_path) == 0 then
      print("Failed to create directory: " .. dir_name)
      return
    end
    vim.cmd('e ' .. vim.fn.fnameescape(curdir))
    -- 匹配带 / 的目录名
    vim.defer_fn(function()
      vim.fn.search('^' .. vim.fn.escape(dir_name, '[]') .. '/$', 'c')
    end, 50)
  end
end, { remap = true, buffer = true })
-- toggle hidden file
map('n', '.', 'gh', { remap = true, buffer = true })
-- delete file
map('n', 'd', function()
  local path = vim.b.netrw_curdir
  local file = vim.fn.expand("<cfile>")
  local current_path = path .. '/' .. file;
  if vim.fn.isdirectory(current_path) == 1 then
    local confirmation = vim.fn.input("Delete directory " .. current_path .. " and its contents? (y/n): ")
    if confirmation == 'y' or confirmation == 'Y' then
      vim.fn.system('rm -r ' .. current_path)
    end
  else
    local confirmation = vim.fn.input("Delete file " .. current_path .. "? (y/n): ")
    if confirmation == 'y' or confirmation == 'Y' then
      vim.fn.delete(current_path)
    end
  end
  vim.cmd('edit ' .. path)
end, { remap = true, buffer = true, nowait = true })
-- backward
map('n', 'h', '-', { remap = true, buffer = true })
-- forward
map('n', 'l', '<CR>', { remap = true, buffer = true })
-- rename
map('n', 'r', 'R', { remap = true, buffer = true })
-- search in the dir under cursor
map('n', '<leader>fd', function()
  local path = vim.api.nvim_exec2("echo b:netrw_curdir", { output = true }).output;
  local file = vim.api.nvim_exec2("echo expand('<cfile>')", { output = true }).output;
  local fullPath = path .. '/' .. file;
  require("fzf-lua").grep({
    cwd = fullPath, -- 指定搜索目录
  })
end, { remap = true, buffer = true })

-- 搜索文件
map('n', '<leader>ff', function()
  local path = vim.api.nvim_exec2("echo b:netrw_curdir", { output = true }).output;
  local file = vim.api.nvim_exec2("echo expand('<cfile>')", { output = true }).output;
  local fullPath
  
  -- 如果当前选中的是文件，则使用其所在目录；如果是目录，则使用该目录
  if vim.fn.isdirectory(path .. '/' .. file) == 1 then
    fullPath = path .. '/' .. file
  else
    fullPath = path
  end
  
  require("fzf-lua").files({
    cwd = fullPath, -- 指定搜索目录
  })
end, { remap = true, buffer = true })
-- reveal in finder
map('n', '<leader>fo', function()
  local path = vim.api.nvim_exec2("echo b:netrw_curdir", { output = true }).output;
  local file = vim.api.nvim_exec2("echo expand('<cfile>')", { output = true }).output;
  local fullPath = path .. '/' .. file;
  vim.fn.jobstart('open -R "' .. fullPath .. '"', { detach = true })
end, { remap = true, buffer = true })
