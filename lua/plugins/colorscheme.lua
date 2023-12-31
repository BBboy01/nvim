return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme solarized-osaka')
      vim.cmd.highlight('default link IndentLine Comment')
    end,
  },
}
