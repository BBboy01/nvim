---@type LazySpec
return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('solarized-osaka')
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
    end,
  },
}
