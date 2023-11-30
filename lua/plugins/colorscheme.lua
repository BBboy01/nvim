return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    ---@type Config
    opts = {
      transparent = true,
    },
    config = function(_, opts)
      require('solarized-osaka').setup(opts)
      vim.cmd('colorscheme solarized-osaka')
      vim.cmd.highlight('default link IndentLine Comment')
    end,
  },
}
