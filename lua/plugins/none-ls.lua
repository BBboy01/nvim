return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.dprint.with({
          filetypes = { 'json', 'jsonc', 'markdown', 'python', 'toml' },
        }),
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.rustfmt.with({
          extra_args = { '--edition', '2021' },
        }),
        null_ls.builtins.diagnostics.eslint_d.with({
          diagnostics_format = '[eslint] #{m}\n(#{c})',
        }),
        null_ls.builtins.diagnostics.fish,
      },
    })
  end,
}
