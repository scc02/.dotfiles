local M = {}

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",

  "fugitive",
  "git",
  "gitcommit",
  "TelescopePrompt",
  "", -- nvim初始界面
  "DiffviewFileHistory",
}

local excludes = function()
  local modifiable = vim.api.nvim_eval("&ma")
  local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  if file_name:match("%.lock$") then
    return false
  end
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) or modifiable == 0 or diffviewOpen then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

local normal_hl_id = vim.fn.hlID('Normal')
local bg_trans_id = vim.fn.synIDtrans(normal_hl_id)
vim.api.nvim_set_hl(0, 'WinBarPath', { bg = vim.fn.synIDattr(bg_trans_id, 'bg#b'), fg = '#adbac7' })
vim.api.nvim_set_hl(0, 'WinBarModified', { bg = '#282c34', fg = '#ff3838' })
-- vim.api.nvim_set_hl(0, 'WinBar', { bg = '#073642' })
-- vim.api.nvim_set_hl(0, 'WinBarPath', { bg = '#073642', fg = '#adbac7' })

function M.get_winbar()
  if excludes() then
    return
  end
  -- local file_path = vim.api.nvim_eval_statusline('%f', {}).str
  local file_path = vim.api.nvim_eval('fnamemodify(expand("%"), ":~:.")')
  local modified = vim.api.nvim_eval_statusline('%M', {}).str == '+' and ' ⊚' or ''

  file_path = file_path:gsub('/', ' ➤ ')

  local value = '  %#WinBarPath#'
      .. file_path
      .. '%*'
  -- .. '%#WinBarModified#'
  -- .. modified
  -- .. '%*'

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

return M
