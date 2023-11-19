local keymap = vim.keymap

-- Do not yank
keymap.set('n', 'x', '"_x')

keymap.set('x', 'p', '"_dP')

keymap.set('n', '<leader>l', ':set hlsearch!<CR>', {
  noremap = true,
  silent = true,
  desc = 'Toggle matched highlight status',
})

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

keymap.set('n', 'te', ':tabedit<Return>', { silent = true, desc = 'Create a new tab' })
keymap.set('n', 'tp', ':tabprevious<Return>', { silent = true, desc = 'Switch to previous tab' })
keymap.set('n', 'tn', ':tabnext<Return>', { silent = true, desc = 'Switch to next tab' })
keymap.set('n', 'to', ':tabo<Return>', { silent = true, desc = 'Close all tabs but current' })

keymap.set('n', 'si', ':split<Return><C-w>w', { silent = true, desc = 'Horizontally split current buffer' })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true, desc = 'Vertically split current buffer' })

keymap.set('', 'sh', '<C-w>h', { desc = 'Move focus to left window' })
keymap.set('', 'sk', '<C-w>k', { desc = 'Move focus to upper window' })
keymap.set('', 'sj', '<C-w>j', { desc = 'Move focus to lower window' })
keymap.set('', 'sl', '<C-w>l', { desc = 'Move focus to right window' })

keymap.set('n', 'sw', ':q<CR>', { desc = 'Save and Close current buffer' })
keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save current buffer' })

keymap.set('n', 's<right>', '<C-w><', { desc = 'Decrease window width' })
keymap.set('n', 's<left>', '<C-w>>', { desc = 'Increase window width' })
keymap.set('n', 's<up>', '<C-w>+', { desc = 'Increase window height' })
keymap.set('n', 's<down>', '<C-w>-', { desc = 'Decrease window height' })

keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = 'Indent selected text' })
keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = 'Unindent selected text' })

keymap.set('x', 'K', ":move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = 'Move selected text up' })
keymap.set('x', 'J', ":move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = 'Move selected text down' })
