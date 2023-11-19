return {
  'hrsh7th/nvim-cmp',
  version = false,
  event = 'InsertEnter',
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
  opts = function()
    local cmp = require('cmp')
    local defaults = require('cmp.config.default')()
    return {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-q>'] = cmp.mapping.close(),
        ['<Tab>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      }, {
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
  ---@param opts cmp.ConfigSchema
  config = function(_, opts)
    for _, source in ipairs(opts.sources) do
      source.group_index = source.group_index or 1
    end
    require('cmp').setup(opts)
  end,
}
