vim.loader.enable()

require('config.options')
require('config.autocmds')
require('config.keymaps')
require('config.lazy')

if vim.g.neovide then
  vim.api.nvim_set_hl(0, 'Normal', { bg = '#001E27' })
  vim.g.neovide_transparency = 0.92
  vim.g.neovide_window_blurred = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_macos_option_is_meta = 'only_left'
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end
