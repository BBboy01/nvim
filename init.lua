require('base')
require('globals')
require('highlights')
require('maps')
require('plugins')

local os = vim.loop.os_uname().sysname

if os == 'Darwin' then
  vim.opt.clipboard:append({ 'unnamedplus' })
elseif os == 'Linux' then
  vim.opt.clipboard:append({ 'unnamedplus' })
elseif os == 'Windows_NT' then
  vim.opt.clipboard:prepend({ 'unnamed', 'unnamedplus' })
else
  error('Init failed: unknown OS')
end

if vim.g.neovide then
  -- Helper function for transparency formatting
  local alpha = function()
    return string.format('%x', math.floor(255 * (vim.g.transparency or 0.8)))
  end
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 0.8
  vim.g.neovide_background_color = '#002129' .. alpha()
  vim.g.neovide_cursor_vfx_mode = 'torpedo'
end
