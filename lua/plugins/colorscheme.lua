return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme solarized-osaka')
      vim.api.nvim_set_hl(0, 'WinBar', {})
      vim.api.nvim_set_hl(0, 'WinBarNC', {})
    end,
  },
}
