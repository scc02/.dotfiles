local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 10
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  direction = 'float',
  float_opts = {
    border = 'rounded'
  },
  -- -- 关键：终端创建后立即禁用 <Esc>
  -- on_create = function()
  --   local opts = { buffer = 0, silent = true }  -- buffer=0 表示当前终端缓冲区
  --   vim.keymap.set('t', '<Esc>', '<Nop>', opts) -- 完全禁用 Esc
  -- end,
})
