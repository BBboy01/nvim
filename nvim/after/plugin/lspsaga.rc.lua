local status, saga = pcall(require, 'lspsaga')
if (not status) then return end

saga.init_lsp_saga {
  server_filetype_map = {}
}



local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-j>', '<Cmd>lspsaga diagnostic_jump_next<cr>', opts)
vim.keymap.set('n', 'gh', '<Cmd>lspsaga hover_doc<cr>', opts)
vim.keymap.set('n', 'gd', '<cmd>Lspsaga lsp_finder<CR>', opts)
vim.keymap.set('i', '<C-k>', '<Cmd>lspsaga signature_help<cr>', opts)
vim.keymap.set('n', 'gp', '<Cmd>lspsaga preview_defination<cr>', opts)
vim.keymap.set('n', '<Leader>n', '<Cmd>lspsaga rename<cr>', opts)
