local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'folke/neodev.nvim',
  {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = true,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        ' s',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Flash Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'svrana/neosolarized.nvim',
    dependencies = { 'tjdevries/colorbuddy.nvim' },
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
  }, -- Statusline
  'onsails/lspkind-nvim', -- vscode-like pictograms

  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
  },

  -- CMP
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      { 'hrsh7th/cmp-nvim-lsp', dependencies = 'nvim-lspconfig' }, -- nvim-cmp source for neovim's built-in LSP
      { 'hrsh7th/cmp-path', dependencies = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', dependencies = 'nvim-cmp' }, -- nvim-cmp source for buffer words
      { 'saadparwaiz1/cmp_luasnip', dependencies = 'LuaSnip' },
      {
        'L3MON4D3/LuaSnip',
        event = 'InsertCharPre',
      },
    },
  },

  {
    'github/copilot.vim',
    event = 'VeryLazy',
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'VeryLazy',
  }, -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  {
    'MunifTanjim/prettier.nvim',
    event = 'VeryLazy',
  }, -- Prettier plugin for Neovim's built-in LSP client

  {
    'glepnir/lspsaga.nvim',
    event = 'VeryLazy',
  }, -- LSP UIs
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    run = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },
  'p00f/nvim-ts-rainbow', -- Rainbow parentheses
  'nvim-tree/nvim-web-devicons', -- File icons
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
  },
  {
    'kyazdani42/nvim-tree.lua',
    commit = '086bf310bd19a7103ee7d761eb59f89f3dd23e21',
  }, -- File explore
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
  },
  {
    'nvimdev/indentmini.nvim',
    event = 'BufEnter',
    config = function()
      require('indentmini').setup({
        char = '|',
        exclude = {
          'erlang',
          'markdown',
        },
      })
      -- use comment color
      vim.cmd.highlight('default link IndentLine Comment')
    end,
  },
  'norcalli/nvim-colorizer.lua',
  'b0o/schemastore.nvim', -- json schemas to use with lspconfig

  -- Commnet
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
  },

  -- Surround
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  -- Zen
  {
    'folke/zen-mode.nvim',
    event = 'VeryLazy',
  },
  {
    'folke/twilight.nvim',
    event = 'VeryLazy',
  },

  'akinsho/nvim-bufferline.lua',

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
  },
  {
    'dinhhuy258/git.nvim',
    event = 'VeryLazy',
  }, -- For git blame & browse
})
