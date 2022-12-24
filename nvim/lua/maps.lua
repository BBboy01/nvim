local keymap = vim.keymap

-- Do not yank
keymap.set('n', 'x', '"_x')

keymap.set('x', 'p', '\"_dP')

-- Toggle matched highlight status
keymap.set('n', '<leader>l', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- New tab
keymap.set('n', 'te', ':tabedit<Return>', { silent = true })
-- Only keep currnt tab
keymap.set('n', 'to', ':tabo<Return>', { silent = true })
-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true })
-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')
-- Close window
keymap.set('n', 'sw', ':q<CR>')
-- Save current buffer
keymap.set('n', '<C-s>', ':w<CR>')

-- Resize window
keymap.set('n', 's<right>', '<C-w><')
keymap.set('n', 's<left>', '<C-w>>')
keymap.set('n', 's<up>', '<C-w>+')
keymap.set('n', 's<down>', '<C-w>-')

-- Keep indent selection status
keymap.set('v', '>', '>gv', { noremap = true, silent = true })
keymap.set('v', '<', '<gv', { noremap = true, silent = true })

-- Move selected line/block of text in visual mode
keymap.set('x', 'K', ':move \'<-2<CR>gv-gv', { noremap = true, silent = true })
keymap.set('x', 'J', ':move \'>+1<CR>gv-gv', { noremap = true, silent = true })
