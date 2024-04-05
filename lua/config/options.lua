vim.cmd('autocmd!')

vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

local opt = vim.opt

opt.number = true -- Print line number
opt.signcolumn = 'yes' -- Always show the signcolumn
opt.laststatus = 3 -- Global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.showmode = false -- Don't show the mode, since it's already in status line

opt.pumheight = 15 -- Maximum number of entries in a popup
opt.pumblend = 10 -- Popup blend

opt.listchars = { tab = '» ', nbsp = '+', trail = '·', extends = '→', precedes = '←' } -- Sets how neovim will display certain whitespace in the editor
opt.undofile = true -- Save undo history

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

opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'

opt.formatoptions = 'jcroqlnt' -- tcqj
opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer

vim.g.skip_ts_context_commentstring_module = true
vim.g.nonels_supress_issue58 = true
