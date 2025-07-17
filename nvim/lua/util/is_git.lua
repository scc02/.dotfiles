local M = {}
M.is_git_dir = function()
  local cmd = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  local result = cmd:read("*a")
  cmd:close()

  return result == "true\n"
end

return M
