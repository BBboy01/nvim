local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'folke/neodev.nvim',
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "ss",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    'svrana/neosolarized.nvim',
    dependencies = { 'tjdevries/colorbuddy.nvim' }
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = true,
  },                       -- Statusline
  'nvim-lua/plenary.nvim', -- Common utilities
  'onsails/lspkind-nvim',  -- vscode-like pictograms

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    }
  },

  -- CMP
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'L3MON4D3/LuaSnip',
      { 'hrsh7th/cmp-nvim-lsp',     dependencies = 'nvim-lspconfig' }, -- nvim-cmp source for neovim's built-in LSP
      { 'hrsh7th/cmp-path',         dependencies = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer',       dependencies = 'nvim-cmp' },       -- nvim-cmp source for buffer words
      { 'saadparwaiz1/cmp_luasnip', dependencies = 'LuaSnip' },
    },
  },

  'github/copilot.vim',
  'jose-elias-alvarez/null-ls.nvim', -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  'MunifTanjim/prettier.nvim',       -- Prettier plugin for Neovim's built-in LSP client

  'glepnir/lspsaga.nvim',            -- LSP UIs
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  },
  'nvim-treesitter/nvim-treesitter-textobjects',
  'p00f/nvim-ts-rainbow',                                                              -- Rainbow parentheses
  'nvim-treesitter/playground',                                                        -- Syntax token tree playground
  'nvim-tree/nvim-web-devicons',                                                       -- File icons
  'nvim-telescope/telescope.nvim',
  { 'kyazdani42/nvim-tree.lua', commit = "086bf310bd19a7103ee7d761eb59f89f3dd23e21" }, -- File explore
  'nvim-telescope/telescope-file-browser.nvim',                                        -- Telescope file explore
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  'norcalli/nvim-colorizer.lua',
  "lukas-reineke/indent-blankline.nvim",
  "b0o/schemastore.nvim", -- json schemas to use with lspconfig

  -- Commnet
  "numToStr/Comment.nvim",
  'JoosepAlviste/nvim-ts-context-commentstring',

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  -- Zen
  'folke/zen-mode.nvim',
  'folke/twilight.nvim',

  'akinsho/nvim-bufferline.lua',

  -- Git
  'lewis6991/gitsigns.nvim',
  'dinhhuy258/git.nvim', -- For git blame & browse
})
