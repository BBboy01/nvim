return {
  {
    'danymat/neogen',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = true,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  'b0o/schemastore.nvim', -- json schemas to use with lspconfig
}
