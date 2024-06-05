local config = require('config')

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      ---@type lsp.ClientCapabilities
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
      ---@type table<string, lspconfig.Config>
      servers = {
        html = {},
        cssls = {},
        eslint = {},
        stylelint_lsp = {
          filetypes = {
            'css',
            'less',
            'scss',
            'sugarss',
            'vue',
            'wxss',
          },
        },
        emmet_language_server = {},
        css_variables = {},
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        angularls = {
          ---@diagnostic disable-next-line: assign-type-mismatch
          root_dir = function(...)
            return require('lspconfig.util').root_pattern('nx.json', 'angular.json')(...)
          end,
        },
        gopls = {},
        golangci_lint_ls = {},
        tailwindcss = {},
        tsserver = {},
        pylsp = {},
        sqls = {},
        nginx_language_server = { enabled = false },
        gitlab_ci_ls = {},
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
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              'force',
              new_config.settings.yaml.schemas or {},
              require('schemastore').yaml.schemas()
            )
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
            if not vim.loop.fs_stat(client.workspace_folders[1].name .. '/lazy-lock.json') then
              return
            end
          end,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                },
              },
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
        return opts.diagnostics.signs.text[diagnostic.severity]
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- setup lsp by mason-lspconfig
      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        opts.capabilities
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require('lspconfig')[server].setup(server_opts)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts.enabled ~= false then
          ensure_installed[#ensure_installed + 1] = server
        end
      end
      require('mason-lspconfig').setup({
        ensure_installed = ensure_installed,
        handlers = { setup },
      })
    end,
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    opts = {
      ensure_installed = {
        'lua-language-server',
        'rust-analyzer',
        'gopls',
        'golangci-lint-langserver',
        'angular-language-server',
        'bash-language-server',
        'python-lsp-server',
        'sqls',
        'gitlab-ci-ls',
        'yaml-language-server',
        'typescript-language-server',
        'tailwindcss-language-server',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'nginx-language-server',
        'stylelint-lsp',
        'emmet-language-server',
        'eslint-lsp',
        'json-lsp',
        'html-lsp',
        'css-lsp',
        'css-variables-language-server',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')
      mr:on('package:install:success', function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require('lazy.core.handler.event').trigger({
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
