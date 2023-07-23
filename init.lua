require('base')
require('globals')
require('highlights')
require('maps')
require('plugins')

local has = function(x)
  return vim.fn.has(x) == 1
end

local is_mac = has('macunix')
local is_win = has('win32')

if is_mac then
  require('macos')
end
if is_win then
  require('windows')
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
