vim.opt_local.spell = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '|setlocal spell< wrap< linebreak< breakindent<'
