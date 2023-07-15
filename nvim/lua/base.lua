vim.cmd('autocmd!')

local g = vim.g
local opt = vim.opt

g.mapleader = ';'
g.maplocalleader = ';'

--[[ vim.g.copilot_no_tab_map = true ]]

--[[ vim.scriptencoding = 'utf-8' ]]
vim.b.fileencoding = 'utf-8'

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.number = true
opt.signcolumn = 'yes'

opt.title = true
opt.spell = true
opt.autoindent = true
opt.hlsearch = true
opt.backup = false
opt.writebackup = false
opt.showcmd = true
opt.showmode = false
opt.cmdheight = 1
opt.laststatus = 2
opt.expandtab = true
opt.scrolloff = 10
opt.shell = 'fish'
opt.backupskip = '/tmp/*,/private/tmp/*'
opt.inccommand = 'split'
opt.ignorecase = true
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.ai = true            -- Auto indent
opt.si = true            -- Smart indent
opt.wrap = false         -- No wrap lines
opt.updatetime = 300     -- Faster completion
opt.backspace = 'start,eol,indent'
opt.path:append { '**' } -- Finding files - Search down into subfolders
opt.wildignore:append { '*/node_modules/*' }

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- but this doesn't work on iTerm2.

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

opt.formatoptions:append { 'r' }
