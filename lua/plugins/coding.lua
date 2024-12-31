---@type LazySpec
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        '${3rd}/busted/library',
      },
    },
  },

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
      'hrsh7th/cmp-nvim-lsp-signature-help',
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
      local cmp = require('cmp')
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
          { name = 'buffer', keyword_length = 3 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'path' },
          {
            name = 'lazydev',
            group_index = 0, -- skip loading LuaLS completions
          },
        }),
        formatting = {
          format = function(entry, item)
            local color_item = require('nvim-highlight-colors').format(entry, { kind = item.kind })
            item.kind = require('mini.icons').get('lsp', item.kind) .. ' ' .. item.kind
            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = color_item.abbr
            end
            return item
          end,
        },
        experimental = {
          ghost_text = true,
        },
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
        completion = {
          completeopt = 'menu,menuone,preview,noselect',
        },
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
    cmd = { 'TSUpdate', 'TSInstall' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ensure_installed = {
        'diff',
        'git_config',
        'gitcommit',
        'git_rebase',
        'gitignore',
        'gitattributes',
        'printf',
        'bash',
        'fish',
        'make',
        'cmake',
        'tmux',
        'dot',
        'http',
        'dockerfile',
        'xml',
        'yaml',
        'toml',
        'json',
        'json5',
        'jsonc',
        'mermaid',
        'lua',
        'luap',
        'luadoc',
        'markdown_inline',
        'query',
        'regex',
        'html',
        'jsdoc',
        'javascript',
        'typescript',
        'tsx',
        'styled',
        'vue',
        'svelte',
        'astro',
        'angular',
        'css',
        'scss',
        'vim',
        'vimdoc',
        'rust',
        'ruby',
        'python',
        'c',
        'cpp',
        'go',
        'gomod',
        'gotmpl',
        'sql',
        'graphql',
        'nginx',
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']a'] = '@assignment.rhs',
            [']r'] = '@return.outer',
            [']l'] = '@statement.outer',
          },
          goto_next_end = {
            [']F'] = '@function.inner',
            [']C'] = '@class.inner',
            [']R'] = '@return.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[a'] = '@assignment.lhs',
            ['[r'] = '@return.outer',
            ['[l'] = '@statement.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.inner',
            ['[C'] = '@class.inner',
            ['[R'] = '@return.inner',
          },
        },
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ar'] = '@return.outer',
            ['ir'] = '@return.inner',
            ['al'] = '@statement.outer',
            ['il'] = '@statement.inner',
            ['iL'] = '@assignment.lhs',
            ['iR'] = '@assignment.rhs',
          },
        },
      },
      highlight = {
        enable = true,
        disable = function(_, buf)
          if vim.api.nvim_buf_line_count(buf) > 3000 then
            return true
          end

          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
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
          ['.*gitlab%-ci.*'] = 'yaml.gitlab',
        },
      })
      vim.treesitter.language.register('angular', 'html')
      vim.treesitter.language.register('markdown', 'mdx')
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
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
    commit = 'b066152fe06122b047a6b3ce427a19d8b6e628ce',
    event = { 'BufReadPre', 'BufNewFile' },
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

      ft('lua'):fmt(formatter.stylua)

      ft('go'):fmt(formatter.gofmt)

      ft('sh'):fmt(formatter.shfmt):lint(linter.shellcheck)

      ft('fish'):fmt(formatter.fish_indent)

      ft('rust'):fmt(formatter.rustfmt)

      ft('typescript,javascript,typescriptreact,javascriptreact,vue'):fmt(formatter.prettier)

      ft('css,scss'):fmt(formatter.prettier)

      ft('html,markdown,json,jsonc,yaml'):fmt(formatter.prettier)

      require('guard').setup({
        fmt_on_save = false,
        save_on_fmt = false,
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
