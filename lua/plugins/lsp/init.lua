local config = require('config')

return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  ---@class PluginLspOpts
  opts = {
    capabilities = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
    ---@type vim.diagnostic.Opts
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
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = config.icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = config.icons.diagnostics.Warn,
          [vim.diagnostic.severity.HINT] = config.icons.diagnostics.Hint,
          [vim.diagnostic.severity.INFO] = config.icons.diagnostics.Info,
        },
      },
    },
    servers = {
      html = {},
      cssls = {},
      emmet_ls = {},
      volar = {},
      bashls = {},
      dockerls = {},
      angularls = {
        root_dir = function(...)
          return require('lspconfig.util').root_pattern('.git')(...)
        end,
      },
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
              extraArgs = { '--no-deps' },
              allFeatures = true,
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
              allFeatures = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
      lua_ls = {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/lazy-lock.json') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = vim.split(package.path, ';'),
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                vim.fn.stdpath('data') .. '/lazy',
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              },
            },
          })
        end,
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            diagnostics = {
              globals = { 'vim' },
            },
            completion = {
              callSnippet = 'Replace',
              keywordSnippet = 'Disable',
            },
            doc = {
              privateName = { '^_' },
            },
          },
        },
      },
    },
    setup = {},
  },
  ---@param opts PluginLspOpts
  config = function(_, opts)
    local register_capability = vim.lsp.handlers['client/registerCapability']

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
      local ret = register_capability(err, res, ctx)
      ---@type lsp.Client
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local buffer = vim.api.nvim_get_current_buf()
      require('plugins.lsp.keymaps').on_attach(client, buffer)
      return ret
    end

    -- diagnostics signs
    if vim.fn.has('nvim-0.10.0') == 0 then
      for severity, icon in pairs(opts.diagnostics.signs.text) do
        local name = vim.diagnostic.severity[severity]:lower():gsub('^%l', string.upper)
        name = 'DiagnosticSign' .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if not ok then
      vim.notify('Could not load nvim-cmp')
      return
    end
    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      opts.capabilities
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
