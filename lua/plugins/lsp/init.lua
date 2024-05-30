local config = require('config')

return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  ---@class PluginLspOpts
  opts = {
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
    ---@type vim.diagnostic.Opts
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = 'if_many',
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = config.icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = config.icons.diagnostics.Warn,
          [vim.diagnostic.severity.INFO] = config.icons.diagnostics.Info,
          [vim.diagnostic.severity.HINT] = config.icons.diagnostics.Hint,
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
          return require('lspconfig.util').root_pattern('nx.json', 'angular.json')(...)
        end,
      },
      gopls = {},
      tailwindcss = {},
      tsserver = {},
      jsonls = {
        on_new_config = function(new_config)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
        end,
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas =
            vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = {
              enable = true,
            },
            validate = true,
            schemaStore = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
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
  },
  ---@param opts PluginLspOpts
  config = function(_, opts)
    -- setup keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local buffer = args.buf ---@type number
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          return require('plugins.lsp.keymaps').on_attach(client, buffer)
        end
      end,
    })

    -- setup diagnostics signs
    opts.diagnostics.virtual_text.prefix = function(diagnostic)
      local icons = opts.diagnostics.signs.text or {}
      return icons[diagnostic.severity]
    end
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local capabilities = vim.tbl_deep_extend(
      'force',
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities(),
      opts.capabilities
    )

    -- setup servers
    for server, server_opts in pairs(servers) do
      require('lspconfig')[server].setup(vim.tbl_deep_extend('force', {
        capabilities = vim.deepcopy(capabilities),
      }, server_opts))
    end
  end,
}
