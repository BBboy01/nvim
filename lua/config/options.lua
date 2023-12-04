vim.cmd('autocmd!')

local g = vim.g
local opt = vim.opt

g.mapleader = ';'
g.maplocalleader = ';'

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.number = true
opt.signcolumn = 'yes'

opt.cmdheight = 0
opt.laststatus = 3
opt.list = true

opt.ruler = false
opt.showtabline = 0
opt.winwidth = 30
opt.pumheight = 15
opt.showcmd = false
opt.hidden = true

opt.listchars = { tab = '»·', nbsp = '+', trail = '·', extends = '→', precedes = '←' }
opt.pumblend = 10
opt.winblend = 10
opt.undofile = true

opt.magic = true
opt.title = true
opt.autoindent = true
opt.hlsearch = true
opt.backup = false
opt.writebackup = false
opt.showmode = false
opt.expandtab = true
opt.scrolloff = 2
opt.sidescrolloff = 5
opt.shell = 'fish'
opt.backupskip = '/tmp/*,/private/tmp/*'
opt.inccommand = 'split'
opt.ignorecase = true
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.ai = true -- Auto indent
opt.si = true -- Smart indent
opt.wrap = false -- No wrap lines
opt.updatetime = 300 -- Faster completion
opt.backspace = 'start,eol,indent'
opt.path:append({ '**' }) -- Finding files - Search down into subfolders
opt.wildignore:append({ '*/node_modules/*' })

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'

vim.opt.mouse = ''

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste',
})

opt.formatoptions:append({ 'r' })

if vim.fn.executable('rg') == 1 then
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
  opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

vim.opt.clipboard:append({ 'unnamedplus' })
vim.g.skip_ts_context_commentstring_module = true
