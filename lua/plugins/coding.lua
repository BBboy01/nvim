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
    'nvim-mini/mini.surround',
    lazy = false,
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add, desc = 'Add surrounding' },
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
        add = 'sa',
        delete = 'sd',
        replace = 'sr',
        highlight = '',
        find = '',
        find_left = '',
      },
    },
  },

  {
    'saghen/blink.cmp',
    dependencies = {
      'xzbdmw/colorful-menu.nvim',
      {
        'L3MON4D3/LuaSnip',
        lazy = true,
        event = { 'BufEnter' },
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
        opts = {
          history = true,
          delete_check_events = 'TextChanged',
        },
        config = function()
          local ls = require('luasnip')
          ls.filetype_extend('javascript', { 'jsdoc' })
          ls.filetype_extend('typescript', { 'javascript', 'tsdoc' })
          ls.filetype_extend('vue', { 'javascript' })
          require('luasnip.loaders.from_vscode').lazy_load()
          require('luasnip.loaders.from_lua').lazy_load({ paths = { vim.fn.stdpath('config') .. '/lua/snippets' } })
        end,
      },
      {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
        opts = {
          lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
          },
        },
        config = function(_, opts)
          require('crates').setup(opts)
        end,
      },
    },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ['<C-k>'] = { 'show' },
      },
      completion = {
        menu = {
          draw = {
            columns = { { 'label' }, { 'kind_icon', 'kind', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
              kind_icon = {
                text = function(ctx)
                  local icon = require('mini.icons').get('lsp', ctx.kind)
                  if ctx.item.source_name == 'LSP' then
                    local color_item =
                      require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= '' then
                      icon = color_item.abbr
                    end
                  end
                  return icon .. ctx.icon_gap
                end,
              },
            },
          },
        },
        documentation = { auto_show = true },
        list = { selection = { auto_insert = false } },
        ghost_text = { enabled = true },
      },
      cmdline = {
        keymap = {
          ['<C-k>'] = { 'show' },
        },
        completion = {
          list = {
            selection = {
              auto_insert = false,
            },
          },
          menu = { auto_show = true },
        },
      },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lazydev', 'lsp', 'buffer', 'snippets', 'path' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = 'BufRead',
    init = function()
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
        'glsl',
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']r'] = '@return.outer',
          },
          goto_next_end = {
            [']F'] = '@function.inner',
            [']C'] = '@class.inner',
            [']R'] = '@return.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[r'] = '@return.outer',
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
          ['.*gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
        },
      })
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
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvimdev/guard-collection',
    },
    keys = {
      {
        '<Leader>f',
        '<cmd>Guard fmt<cr>',
        desc = 'Format current buffer',
      },
    },
    config = function()
      vim.g.guard_config = {
        fmt_on_save = false,
        lsp_as_default_formatter = true,
        save_on_fmt = false,
        auto_lint = false,
      }

      local ft = require('guard.filetype')
      local formatter = require('guard-collection.formatter')
      local linter = require('guard-collection.linter')

      ft('lua'):fmt(formatter.stylua)
      ft('go'):fmt(formatter.gofumpt)
      ft('sh'):fmt(formatter.shfmt):lint(linter.shellcheck)
      ft('fish'):fmt(formatter.fish_indent)
      ft('rust'):fmt(formatter.rustfmt)
      ft('typescript,javascript,typescriptreact,javascriptreact,vue'):fmt(formatter.prettier)
      ft('css,scss'):fmt(formatter.prettier)
      ft('html,htmlangular,markdown,json,jsonc,yaml'):fmt(formatter.prettier)
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
