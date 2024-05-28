return {
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
    config = function(ops)
      local snip = require('luasnip')

      snip.setup(ops)

      snip.filetype_extend('javascriptreact', { 'javascript' })
      snip.filetype_extend('typescript', { 'javascript' })
      snip.filetype_extend('typescriptreact', { 'javascript' })
      snip.filetype_extend('typescriptreact', { 'javascriptreact' })

      require('luasnip.loaders.from_lua').lazy_load({
        paths = { vim.fn.stdpath('config') .. '/lua/snippets' },
      })
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  {
    'echasnovski/mini.surround',
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'v' } },
        { opts.mappings.delete, desc = 'Delete surrounding' },
        { opts.mappings.replace, desc = 'Replace surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      custom_surroundings = {
        ['b'] = { input = { '%b()', '^.().*().$' }, output = { left = '(', right = ')' } },
        ['B'] = { input = { '%b{}', '^.().*().$' }, output = { left = '{', right = '}' } },
      },
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
        highlight = '', -- remove this internal keymap
        find = '', -- remove this internal keymap
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
        opts = {
          completion = {
            cmp = { enabled = true },
          },
        },
      },
    },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require('cmp')
      local defaults = require('cmp.config.default')()
      local luasnip = require('luasnip')
      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,preview,noselect',
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-q>'] = cmp.mapping.close(),
          ['<C-k>'] = cmp.mapping.complete({}),
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'crates' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer', keyword_length = 3 },
        }),
        formatting = {
          format = function(_, item)
            local icons = require('config').icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
        sorting = defaults.sorting,
      }
    end,
    --@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
    config = function(_, opts)
      local cmp = require('cmp')
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      cmp.setup(opts)
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        }),
      })
    end,
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = 'BufRead',
    init = function(plugin)
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ensure_installed = {
        'bash',
        'diff',
        'html',
        'toml',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'tsx',
        'typescript',
        'vim',
        'angular',
        'vimdoc',
        'yaml',
        'astro',
        'cmake',
        'cpp',
        'css',
        'scss',
        'fish',
        'dockerfile',
        'dot',
        'go',
        'rust',
        'svelte',
        'gitignore',
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        },
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = { query = '@class.inner' },
          },
        },
      },
      highlight = {
        enable = true,
        disable = function(_, buf)
          return vim.api.nvim_buf_line_count(buf) > 3000
        end,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.filetype.add({
        extension = {
          mdx = 'mdx',
        },
        filename = {
          ['.env'] = 'dotenv',
        },
        pattern = {
          ['.*/kitty/.+%.conf'] = 'bash',
          ['%.env%.[%w_.-]+'] = 'dotenv',
        },
      })
      vim.treesitter.language.register('markdown', 'mdx')
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufReadPre' },
    opts = {},
  },

  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit' },
    keys = {
      { ' g', '<cmd>LazyGit<cr>', desc = 'Open lazy git' },
    },
  },

  {
    'nvimdev/guard.nvim',
    dependencies = {
      'nvimdev/guard-collection',
    },
    keys = {
      {
        '<Leader>f',
        '<cmd>GuardFmt<cr>',
        desc = 'Format current buffer',
      },
    },
    config = function()
      local ft = require('guard.filetype')
      local formatter = require('guard-collection.formatter')
      local linter = require('guard-collection.linter')

      ft('lua'):fmt(formatter.stylua):lint(linter.selene)

      ft('go'):fmt(formatter.gofmt):lint(linter.golangci_lint)

      ft('sh'):fmt(formatter.shfmt):lint(linter.shellcheck)

      ft('fish'):fmt(formatter.fish_indent)

      ft('rust'):fmt(formatter.rustfmt)

      ft('toml'):fmt(formatter.dprint)

      ft('typescript,javascript,typescriptreact,javascriptreact,vue'):fmt(formatter.prettier):lint(linter.eslint)

      ft('css,scss'):fmt(formatter.prettier):lint(linter.stylelint)

      ft('html,markdown,json,jsonc,yaml'):fmt(formatter.prettier)

      require('guard').setup({
        fmt_on_save = false,
        lsp_as_default_formatter = true,
      })
    end,
  },

  {
    'laytan/cloak.nvim',
    event = 'BufEnter',
    opts = {
      enabled = true,
      cloak_character = '*',
      -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
      highlight_group = 'Comment',
      -- Applies the length of the replacement characters for all matched
      -- patterns, defaults to the length of the matched pattern.
      cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
      -- Wether it should try every pattern to find the best fit or stop after the first.
      try_all_patterns = true,
      patterns = {
        {
          -- Match any file starting with '.env'.
          -- This can be a table to match multiple file patterns.
          file_pattern = '.env*',
          -- Match an equals sign and any character after it.
          -- This can also be a table of patterns to cloak,
          -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
          cloak_pattern = '=.+',
          -- A function, table or string to generate the replacement.
          -- The actual replacement will contain the 'cloak_character'
          -- where it doesn't cover the original text.
          -- If left emtpy the legacy behavior of keeping the first character is retained.
          replace = nil,
        },
      },
    },
  },
}
