local status, saga = pcall(require, 'lspsaga')
if (not status) then return end

saga.setup {
  server_filetype_map = {},
  symbol_in_winbar = {
    enable = true,
    separator = ' ',
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  },
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>dc', '<Cmd>Lspsaga show_line_diagnostics<cr>', opts)
vim.keymap.set('n', '<leader>dp', '<Cmd>Lspsaga diagnostic_jump_next<cr>', opts)
vim.keymap.set('n', '<leader>dn', '<Cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
vim.keymap.set('n', 'gh', '<Cmd>Lspsaga hover_doc<cr>', opts)
vim.keymap.set('n', 'gr', '<cmd>Lspsaga lsp_finder<CR>', opts)
vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<cr>', opts)
vim.keymap.set('n', 'ga', '<Cmd>Lspsaga code_action<cr>', opts)
vim.keymap.set('n', '<Leader>n', '<Cmd>Lspsaga rename<cr>', opts)
