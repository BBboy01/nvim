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
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'xzbdmw/colorful-menu.nvim',
      {
        'L3MON4D3/LuaSnip',
        event = 'InsertEnter',
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
        event = 'BufRead Cargo.toml',
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
}
