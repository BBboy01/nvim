return {
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },

  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
      'p00f/nvim-ts-rainbow',
    },
    opts = {
      ensure_installed = {
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
      autotag = {
        enable = true,
      },
      -- https://github.com/nvim-treesitter/playground#query-linter
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
      rainbow = {
        enable = true,
        disable = {},
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil,
        colors = {
          '#845EC2',
          '#4FFBDF',
          '#2265DC',
          '#FF8066',
          '#229900',
          '#999900',
          '#FFC75F',
          '#EE66E8',
        }, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@conditional.outer',
            ['ic'] = '@conditional.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = 'mdx',
        },
      })
      vim.treesitter.language.register('markdown', 'mdx')
    end,
  },
}
