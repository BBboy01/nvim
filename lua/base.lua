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

opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'

opt.listchars = 'tab:»·,nbsp:+,trail:·,extends:→,precedes:←'
opt.pumblend = 10
opt.winblend = 10
opt.undofile = true

opt.magic = true
opt.title = true
opt.spell = true
opt.spelloptions = 'camel'
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

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
-- but this doesn't work on iTerm2.

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

local function get_signs()
  local buf = vim.api.nvim_get_current_buf()
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = '*', lnum = vim.v.lnum })[1].signs)
end

local function fill_space(count)
  return '%#StcFill#' .. (' '):rep(count) .. '%*'
end

function _G.show_stc()
  local sign, gitsign
  for _, s in ipairs(get_signs()) do
    if s.name:find('GitSign') then
      gitsign = '%#' .. s.texthl .. '#' .. s.text .. '%*'
    else
      sign = '%#' .. s.texthl .. '#' .. s.text .. '%*'
    end
  end

  local function show_break()
    if vim.v.virtnum > 0 then
      return (' '):rep(math.floor(math.ceil(math.log10(vim.v.lnum))) - 1)
        .. '↳'
    elseif vim.v.virtnum < 0 then
      return ''
    else
      return vim.v.lnum
    end
  end

  return (sign and sign or fill_space(2))
    .. '%='
    .. show_break()
    .. (gitsign and gitsign or fill_space(2))
end

opt.stc = [[%!v:lua.show_stc()]]
