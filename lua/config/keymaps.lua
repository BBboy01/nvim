local map = vim.keymap.set

map('n', 'x', '"_x')

map({ 'i', 'n' }, '<Esc>', '<Cmd>noh<CR><Esc>', { desc = 'Escape and clear hlsearch' })
map('n', '<leader>l', '<Cmd>set hlsearch!<CR>', {
  noremap = true,
  silent = true,
  desc = 'Toggle matched highlight status',
})

-- paste but not yank
map('x', 'p', [["_dP]])

map({ 'i', 'x', 'n', 's' }, '<C-c>', '<Esc>')

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Increment/decrement
map('n', '+', '<C-a>')
map('n', '-', '<C-x>')

-- Delete a word backwards
map('n', 'dw', 'vb"_d')

-- Split window
map('n', 'si', '<Cmd>split<Return><C-w>w', { desc = 'Horizontally split current buffer' })
map('n', 'sv', '<Cmd>vsplit<Return><C-w>w', { desc = 'Vertically split current buffer' })

-- Move window
map('n', 'sh', '<C-w>h', { desc = 'Move focus to left window', remap = true })
map('n', 'sk', '<C-w>k', { desc = 'Move focus to upper window', remap = true })
map('n', 'sj', '<C-w>j', { desc = 'Move focus to lower window', remap = true })
map('n', 'sl', '<C-w>l', { desc = 'Move focus to right window', remap = true })

-- Resize window
map('n', '<A-h>', '<C-w><', { desc = 'Decrease window width' })
map('n', '<A-l>', '<C-w>>', { desc = 'Increase window width' })
map('n', '<A-k>', '<C-w>+', { desc = 'Increase window height' })
map('n', '<A-j>', '<C-w>-', { desc = 'Decrease window height' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')
