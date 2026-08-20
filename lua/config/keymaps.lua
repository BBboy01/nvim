local map = vim.keymap.set

-- Editing
map('n', 'x', '"_x', { desc = 'Delete character without yanking' })
map('x', 'p', [["_dP]], { desc = 'Paste without overwriting the register' })
map('n', 'dw', 'vb"_d', { desc = 'Delete previous word without yanking' })
map('n', '+', '<C-a>', { desc = 'Increment number' })
map('n', '-', '<C-x>', { desc = 'Decrement number' })
map({ 'i', 'n' }, '<Esc>', '<Cmd>noh<CR><Esc>', { desc = 'Escape and clear search highlight' })
map({ 'i', 'x', 'n', 's' }, '<C-c>', '<Esc>', { desc = 'Escape to Normal mode' })
map('n', '<leader>l', '<Cmd>set hlsearch!<CR>', { desc = 'Toggle search highlight' })

map('i', ',', ',<C-g>u', { desc = 'Insert comma with undo break' })
map('i', '.', '.<C-g>u', { desc = 'Insert period with undo break' })
map('i', ';', ';<C-g>u', { desc = 'Insert semicolon with undo break' })
map('v', '<', '<gv', { desc = 'Indent left and reselect' })
map('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Navigation
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down by display line' })
map(
  { 'n', 'x' },
  '<Down>',
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true, desc = 'Move down by display line' }
)
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up by display line' })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up by display line' })

-- Keep n/N moving in the same screen direction regardless of search direction.
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Previous search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })

-- Windows
map('n', 'si', '<Cmd>split<Return><C-w>w', { desc = 'Horizontally split current buffer' })
map('n', 'sv', '<Cmd>vsplit<Return><C-w>w', { desc = 'Vertically split current buffer' })
map('n', 'sh', '<C-w>h', { desc = 'Move focus to left window' })
map('n', 'sk', '<C-w>k', { desc = 'Move focus to upper window' })
map('n', 'sj', '<C-w>j', { desc = 'Move focus to lower window' })
map('n', 'sl', '<C-w>l', { desc = 'Move focus to right window' })
map('n', '<A-h>', '<C-w><', { desc = 'Decrease window width' })
map('n', '<A-l>', '<C-w>>', { desc = 'Increase window width' })
map('n', '<A-k>', '<C-w>+', { desc = 'Increase window height' })
map('n', '<A-j>', '<C-w>-', { desc = 'Decrease window height' })

-- Web search
local function search_web(query)
  query = vim.trim(query)
  if query == '' then
    return
  end
  vim.ui.open(('https://www.google.com/search?q=%s'):format(vim.uri_encode(query)))
end

map('n', 'gX', function()
  search_web(vim.fn.expand('<cword>'))
end, { desc = 'Search word on web' })

map('x', 'gX', function()
  local lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
  search_web(table.concat(lines, ' '))
  vim.api.nvim_input('<Esc>')
end, { desc = 'Search selection on web' })

-- Quit
map('n', '<leader>qq', '<Cmd>qa<CR>', { desc = 'Quit all' })
