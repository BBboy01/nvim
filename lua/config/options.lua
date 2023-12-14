vim.cmd('autocmd!')

vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

local opt = vim.opt

opt.number = true -- Print line number
opt.signcolumn = 'yes' -- Always show the signcolumn
opt.completeopt = 'menu,menuone,noselect'
opt.laststatus = 3 -- Global statusline
opt.list = true -- Show some invisible characters (tabs...

opt.pumheight = 15
opt.pumblend = 10

opt.listchars = { tab = '»·', nbsp = '+', trail = '·', extends = '→', precedes = '←' }
opt.undofile = true

opt.backup = false
opt.writebackup = false
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.expandtab = true -- Use spaces instead of tabs
opt.scrolloff = 2 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.backupskip = '/tmp/*,/private/tmp/*'
opt.inccommand = 'nosplit' -- Preview incremental substitute
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.wrap = false -- No wrap lines
opt.updatetime = 300 -- Faster completion
opt.path:append({ '**' }) -- Finding files - Search down into subfolders
opt.wildignore:append({ '*/node_modules/*' })
opt.wildmode = 'longest:full,full' -- Command-line completion mode

opt.cursorline = true -- Enable highlighting of the current line
opt.termguicolors = true -- True color support

opt.mouse = '' -- Disable mouse action

opt.formatoptions:append({ 'r' })

if vim.fn.executable('rg') == 1 then
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

vim.opt.clipboard:append({ 'unnamedplus' })
vim.g.skip_ts_context_commentstring_module = true
