vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

local opt = vim.opt

-- Editing
opt.mouse = '' -- Disable mouse action
opt.laststatus = 3 -- Global statusline

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'

opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer

opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.spelllang = { 'en' }
opt.spelloptions:append('noplainbuffer')
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.winminwidth = 5 -- Minimum window width

opt.expandtab = true -- Use spaces instead of tabs
opt.backup = false
opt.writebackup = false
opt.backupskip = '/tmp/*,/private/tmp/*'
opt.inccommand = 'nosplit' -- Preview incremental substitute
opt.virtualedit = 'block' -- Select whatever in visual block mode
opt.jumpoptions = 'view'
opt.path:append({ '**' }) -- Finding files - Search down into subfolders
opt.wildignore:append({ '*/node_modules/*' })
opt.wildmode = 'longest:full,full' -- Command-line completion mode

-- Searching
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.infercase = true

-- Indent
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.shiftround = true -- Round indent
opt.smartindent = true -- Insert indents automatically

-- Folding
opt.foldlevel = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldtext = ''

-- Cache/Log file
opt.swapfile = false
opt.undofile = true -- Save undo history
opt.undolevels = 10000

-- Rendering
opt.termguicolors = true -- True color support

-- UI
opt.number = true -- Print line number
opt.wrap = false -- No wrap lines
opt.cursorline = true -- Enable highlighting of the current line
opt.signcolumn = 'yes' -- Always show the signcolumn
opt.showmode = false -- Don't show the mode, since it's already in status line
opt.pumheight = 15 -- Maximum number of entries in a popup
opt.pumblend = 10 -- Popup blend
opt.smoothscroll = true
opt.scrolloff = 2 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.cmdheight = 0 -- Hide cmd line until in use
opt.showmode = false -- Hide vim mode status line
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = { tab = '» ', nbsp = '+', trail = '·', extends = '→', precedes = '←' } -- Sets how neovim will display certain whitespace in the editor
opt.fillchars = { foldopen = '', foldclose = '', fold = ' ', foldsep = ' ', diff = '╱', eob = ' ' }
