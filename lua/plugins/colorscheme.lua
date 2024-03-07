return {
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    commit = '7d08de59374b32dd101359ccb81e9bd9de08db6a',
    config = function()
      vim.cmd('colorscheme solarized-osaka')
      vim.cmd.highlight('default link IndentLine Comment')
    end,
  },
}
