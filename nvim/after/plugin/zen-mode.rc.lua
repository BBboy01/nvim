local status, zm = pcall(require, "zen-mode")
if not status then return end

vim.keymap.set('n', '<Leader>z', '<Cmd>ZenMode<cr>')
zm.setup({})
