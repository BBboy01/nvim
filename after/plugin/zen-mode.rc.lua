local status, zm = pcall(require, "zen-mode")
if not status then return end

vim.keymap.set('n', '<Leader>z', '<Cmd>ZenMode<cr>')
zm.setup {
  window = {
    backdrop = 0.999,
    height = .9,
    width = 140,
  }
}

local status2, tl = pcall(require, 'twilight')
if not status2 then return end

tl.setup {
  context = -1,
  treesitter = false,
}
