---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    opts_extend = { 'ensure_installed' },
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
        'just',
        'make',
        'cmake',
        'dot',
        'http',
        'dockerfile',
        'xml',
        'yaml',
        'toml',
        'json',
        'json5',
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
        'gosum',
        'gomod',
        'gowork',
        'sql',
        'graphql',
        'nginx',
        'glsl',
      },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter')
      local installed = TS.get_installed('parsers')

      local install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, opts.ensure_installed)
      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          print('parsers install done')
        end)
      end
      TS.setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('hyber_treesitter', {}),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if lang == nil or (not vim.tbl_contains(installed, lang)) then
            return
          end

          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          pcall(vim.treesitter.start, ev.buf)
        end,
      })

      vim.filetype.add({
        filename = {
          ['.env'] = 'dotenv',
        },
        pattern = {
          ['.*/kitty/.+%.conf'] = 'bash',
          ['%.env%.[%w_.-]+'] = 'dotenv',
          ['.*gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
        },
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {
      move = {
        set_jumps = true,
        keys = {
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
      },
      select = {
        keys = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter-textobjects')
      TS.setup(opts)
      local installed = require('nvim-treesitter').get_installed('parsers')

      ---@param buf integer
      local attach = function(buf)
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if lang == nil or (not vim.tbl_contains(installed, lang)) then
          return
        end
        if vim.treesitter.query.get(lang, 'textobjects') == nil then
          return
        end
        local moves = vim.tbl_get(opts, 'move', 'keys') ---@type table<string, table<string, string>>
        local selects = vim.tbl_get(opts, 'select', 'keys') ---@type table<string, string>

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            if not vim.wo.diff then
              vim.keymap.set({ 'n', 'x', 'o' }, key, function()
                require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
              end, {
                buffer = buf,
                silent = true,
              })
            end
          end
        end

        for key, query in pairs(selects) do
          if not vim.wo.diff then
            vim.keymap.set({ 'x', 'o' }, key, function()
              require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
            end, {
              buffer = buf,
              silent = true,
            })
          end
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('hyber_treesitter_textobjects', { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {},
  },

  -- rainbow bracket
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufRead',
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterBlue',
          'RainbowDelimiterYellow',
          'RainbowDelimiterCyan',
          'RainbowDelimiterViolet',
          'RainbowDelimiterRed',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
        },
      }
    end,
  },
}
