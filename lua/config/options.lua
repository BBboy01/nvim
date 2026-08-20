vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

local opt = vim.opt

-- General
opt.mouse = ''
opt.clipboard = 'unnamedplus'
opt.confirm = true
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.timeoutlen = 500
opt.updatetime = 200

-- Editing
opt.selection = 'old' -- Keep v$ characterwise so it does not include the line break
opt.virtualedit = 'block'
opt.jumpoptions = 'view'

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true

-- Search and completion
opt.ignorecase = true
opt.smartcase = true
opt.path:append({ '**' })
opt.wildignore:append({ '*/node_modules/*' })
opt.wildmode = { 'longest:full', 'full' }
opt.completeopt = { 'menu', 'menuone', 'fuzzy', 'popup', 'noinsert', 'noselect' }

-- Files and history
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

-- Folding
opt.foldlevel = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldtext = ''

-- UI
opt.laststatus = 3
opt.winminwidth = 5
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.winborder = 'rounded'
opt.ruler = false
opt.wrap = false
opt.cursorline = true
opt.signcolumn = 'yes'
opt.showmode = false
opt.smoothscroll = true
opt.scrolloff = 2
opt.sidescrolloff = 8
opt.cmdheight = 0
opt.list = true
opt.listchars = { tab = '» ', nbsp = '+', trail = '·', extends = '→', precedes = '←' }
opt.fillchars = { foldopen = '', foldclose = '', fold = ' ', foldsep = ' ', diff = '╱', eob = ' ' }
