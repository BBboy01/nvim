---@type LazySpec
return {
  {
    'nvimdev/guard.nvim',
    dependencies = {
      'nvimdev/guard-collection',
    },
    keys = {
      {
        '<Leader>f',
        '<Cmd>Guard fmt<cr>',
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
}
