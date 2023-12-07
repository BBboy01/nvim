local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

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

-- Split window
keymap.set('n', 'si', '<Cmd>split<Return><C-w>w', { desc = 'Horizontally split current buffer' })
keymap.set('n', 'sv', '<Cmd>vsplit<Return><C-w>w', { desc = 'Vertically split current buffer' })

-- Move window
keymap.set('', 'sh', '<C-w>h', { desc = 'Move focus to left window' })
keymap.set('', 'sk', '<C-w>k', { desc = 'Move focus to upper window' })
keymap.set('', 'sj', '<C-w>j', { desc = 'Move focus to lower window' })
keymap.set('', 'sl', '<C-w>l', { desc = 'Move focus to right window' })

-- Resize window
keymap.set('n', 's<right>', '<C-w><', { desc = 'Decrease window width' })
keymap.set('n', 's<left>', '<C-w>>', { desc = 'Increase window width' })
keymap.set('n', 's<up>', '<C-w>+', { desc = 'Increase window height' })
keymap.set('n', 's<down>', '<C-w>-', { desc = 'Decrease window height' })

-- Save & Close buffer
keymap.set('n', 'sw', '<Cmd>:q<CR>', { desc = 'Save and Close current buffer' })
keymap.set('n', '<C-s>', '<Cmd>w<CR>', { desc = 'Save current buffer' })
