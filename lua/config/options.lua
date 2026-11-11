-- Leaders must be set before plugins and keymaps are loaded.
vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

local opt = vim.opt

-- General behavior
opt.mouse = '' -- Keep mouse input disabled for keyboard-first navigation.
opt.clipboard = 'unnamedplus' -- Use the system clipboard for unnamed yanks.
opt.confirm = true -- Confirm before abandoning unsaved changes.
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Reduce routine messages.
opt.timeoutlen = 500 -- Time allowed for mapped-key sequences.
opt.updatetime = 200 -- Keep diagnostics and CursorHold actions responsive.

-- Editing
opt.selection = 'old' -- Keep v$ characterwise so it does not include the line break.
opt.virtualedit = 'block' -- Allow the cursor to move past text in blockwise visual mode.
opt.jumpoptions = 'view' -- Restore the previous view when jumping through the jumplist.
opt.iskeyword:append('-') -- Treat hyphenated names as one word.

-- Indentation
opt.expandtab = true -- Insert spaces instead of tab characters.
opt.tabstop = 2 -- Display a tab as two spaces.
opt.shiftwidth = 2 -- Use two spaces for >>, <<, and automatic indentation.
opt.shiftround = true -- Round indentation to shiftwidth multiples.
opt.smartindent = true -- Apply simple language-aware indentation rules.

-- Search and command-line completion
opt.ignorecase = true -- Ignore case in searches by default.
opt.smartcase = true -- Respect case when the search contains uppercase letters.
opt.path:append({ '**' }) -- Search recursively when resolving file names.
opt.wildmode = { 'longest:full', 'full' } -- Complete the longest common prefix first.
opt.wildignore:append({ '*/node_modules/*' })
opt.completeopt = { 'menu', 'menuone', 'fuzzy', 'popup', 'noinsert', 'noselect' }

-- Files and history
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.writebackup = false -- Do not create a backup while writing.
opt.swapfile = false -- Avoid swap files for this local configuration.
opt.undofile = true -- Keep undo history between sessions.
opt.undolevels = 10000 -- Keep a large in-memory undo history.

-- Folding
opt.foldmethod = 'expr' -- Derive folds from the current buffer's syntax tree.
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99 -- Start with folds open.
opt.foldtext = '' -- Render folded lines using the normal fold styling.

-- UI
opt.laststatus = 3 -- Use one global statusline for all windows.
opt.winminwidth = 5 -- Keep inactive windows usable when space is tight.
opt.termguicolors = true -- Enable 24-bit colors.
opt.number = true -- Show absolute line numbers.
opt.relativenumber = true -- Show relative numbers for jump-friendly navigation.
opt.winborder = 'rounded' -- Use rounded borders for floating windows.
opt.ruler = false -- Keep cursor position information in the statusline.
opt.wrap = false -- Keep long lines on one screen line.
opt.cursorline = true -- Highlight the current line.
opt.signcolumn = 'yes' -- Reserve space for diagnostics and version-control signs.
opt.smoothscroll = true -- Smooth scrolling inside wrapped or virtual lines.
opt.scrolloff = 10 -- Keep context above and below the cursor.
opt.sidescrolloff = 8 -- Keep context to the left and right of the cursor.
opt.cmdheight = 0 -- Use the compact command line when it is idle.
opt.list = true -- Make invisible whitespace inspectable.
opt.listchars = { tab = '» ', nbsp = '+', trail = '·', extends = '→', precedes = '←' }
opt.fillchars = { foldopen = '', foldclose = '', fold = ' ', foldsep = ' ', diff = '╱', eob = ' ' }
