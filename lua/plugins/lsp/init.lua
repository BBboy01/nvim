local Util = require('util')

return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    { 'folke/neodev.nvim', opts = {} },
  },
  keys = {
    {
      '<Leader>f',
      '<Cmd>lua vim.lsp.buf.format()<CR>',
      desc = 'Format current buffer',
    },
  },
  ---@class PluginLspOpts
  opts = {
    inlay_hints = { enabled = true },
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        prefix = '●',
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- prefix = "icons",
      },
      severity_sort = true,
    },
    servers = {
      html = {},
      cssls = {},
      emmet_ls = {},
      volar = {},
      bashls = {},
      dockerls = {},
      angularls = {},
      gopls = {},
      tailwindcss = {
        root_dir = function(...)
          return require('lspconfig.util').root_pattern('.git')(...)
        end,
      },
      tsserver = {
        root_dir = function(...)
          return require('lspconfig.util').root_pattern('.git')(...)
        end,
        single_file_support = false,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'literal',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          json = {
            schemas = require('schemastore').yaml.schemas(),
            validate = { enable = true },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              allTargets = false,
              command = 'clippy',
            },
            imports = {
              granularity = {
                group = 'module',
              },
              prefix = 'self',
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            diagnostics = {
              enable = true,
            },
            completion = {
              callSnippet = 'Replace',
              keywordSnippet = 'Disable',
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
    },
    setup = {},
  },
  ---@param opts PluginLspOpts
  config = function(_, opts)
    -- setup autoformat
    -- Util.format.register(Util.lsp.formatter())

    local register_capability = vim.lsp.handlers['client/registerCapability']

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
      local ret = register_capability(err, res, ctx)
      local client_id = ctx.client_id
      ---@type lsp.Client
      local client = vim.lsp.get_client_by_id(client_id)
      local buffer = vim.api.nvim_get_current_buf()
      require('plugins.lsp.keymaps').on_attach(client, buffer)
      return ret
    end

    -- diagnostics
    for name, icon in pairs(require('config').icons.diagnostics) do
      name = 'DiagnosticSign' .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
    end

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if opts.inlay_hints.enabled and inlay_hint then
      Util.lsp.on_attach(function(client, buffer)
        if client.supports_method('textDocument/inlayHint') then
          inlay_hint(buffer, true)
        end
      end)
    end

    if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
      opts.diagnostics.virtual_text.prefix = vim.fn.has('nvim-0.10.0') == 0 and '●'
        or function(diagnostic)
          local icons = require('config').icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local server_opts = vim.tbl_deep_extend('force', {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup['*'] then
        if opts.setup['*'](server, server_opts) then
          return
        end
      end
      require('lspconfig')[server].setup(server_opts)
    end

    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        setup(server)
      end
    end
  end,
}
