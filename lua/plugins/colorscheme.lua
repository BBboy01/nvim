return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
    config = function(_, opts)
      require('solarized-osaka').setup(opts)
      -- load the colorscheme here
      vim.cmd([[colorscheme solarized-osaka]])
    end,
  },
}
