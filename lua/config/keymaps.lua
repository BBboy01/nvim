local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

keymap.set({ 'i', 'n' }, '<Esc>', '<Cmd>noh<CR><Esc>', { desc = 'Escape and clear hlsearch' })
keymap.set('n', '<leader>l', '<Cmd>set hlsearch!<CR>', {
  noremap = true,
  silent = true,
  desc = 'Toggle matched highlight status',
})

-- paste but not yank
keymap.set('x', 'p', [["_dP]])

keymap.set({ 'i', 'x', 'n', 's' }, '<C-c>', '<Esc>')

-- better up/down
keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Move Lines
keymap.set('n', '<A-k>', '<Cmd>m .-2<cr>==', { desc = 'Move up' })
keymap.set('n', '<A-j>', '<Cmd>m .+1<cr>==', { desc = 'Move down' })
keymap.set('i', '<A-j>', '<esc><Cmd>m .+1<cr>==gi', { desc = 'Move down' })
keymap.set('i', '<A-k>', '<esc><Cmd>m .-2<cr>==gi', { desc = 'Move up' })
keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Split window
keymap.set('n', 'si', '<Cmd>split<Return><C-w>w', { desc = 'Horizontally split current buffer' })
keymap.set('n', 'sv', '<Cmd>vsplit<Return><C-w>w', { desc = 'Vertically split current buffer' })

-- Move window
keymap.set('', 'sh', '<C-w>h', { desc = 'Move focus to left window', remap = true })
keymap.set('', 'sk', '<C-w>k', { desc = 'Move focus to upper window', remap = true })
keymap.set('', 'sj', '<C-w>j', { desc = 'Move focus to lower window', remap = true })
keymap.set('', 'sl', '<C-w>l', { desc = 'Move focus to right window', remap = true })

-- Resize window
keymap.set('n', 's<right>', '<C-w><', { desc = 'Decrease window width' })
keymap.set('n', 's<left>', '<C-w>>', { desc = 'Increase window width' })
keymap.set('n', 's<up>', '<C-w>+', { desc = 'Increase window height' })
keymap.set('n', 's<down>', '<C-w>-', { desc = 'Decrease window height' })

-- Save & Close buffer
keymap.set('n', 'sw', '<Cmd>wq<CR>', { desc = 'Save and Close current buffer' })
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<Cmd>w<CR><Esc>', { desc = 'Save current buffer' })

-- quit
keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Add undo break-points
keymap.set('i', ',', ',<c-g>u')
keymap.set('i', '.', '.<c-g>u')
keymap.set('i', ';', ';<c-g>u')

-- Better indenting
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')
