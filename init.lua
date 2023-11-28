vim.loader.enable()

require('config.options')
require('config.autocmds')
require('config.keymaps')
require('config.lazy')

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
