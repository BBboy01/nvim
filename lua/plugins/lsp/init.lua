return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      { 'williamboman/mason-lspconfig.nvim', config = function() end },
    },
    opts = function()
      -- stylua: ignore
      local vue_typescript_plugin = require('mason-registry')
        .get_package('vue-language-server')
        :get_install_path() .. '/node_modules/@vue/language-server'
      local angular_typescript_plugin = require('mason-registry')
        .get_package('angular-language-server')
        :get_install_path() .. '/node_modules/@angular/language-server'
      local config = require('config')

      return {
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
          emmet_language_server = {},
          css_variables = {},
          eslint = {
            filetypes = {
              'javascript',
              'javascriptreact',
              'javascript.jsx',
              'typescript',
              'typescriptreact',
              'typescript.tsx',
              'vue',
              'svelte',
              'astro',
              'html',
            },
          },
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
          tailwindcss = {},
          bashls = {},
          dockerls = {},
          docker_compose_language_service = {},
          taplo = {},
          gopls = {},
          golangci_lint_ls = {},
          pylsp = {},
          solargraph = {},
          sqls = {},
          nginx_language_server = {},
          gitlab_ci_ls = {},
          ts_ls = { enabled = false },
          vtsls = {
            filetypes = {
              'javascript',
              'javascriptreact',
              'javascript.jsx',
              'typescript',
              'typescriptreact',
              'typescript.tsx',
              'vue',
            },
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
                ts_ls = {
                  globalPlugins = {
                    {
                      name = '@angular/language-server',
                      location = angular_typescript_plugin,
                      enableForWorkspaceTypeScriptVersions = false,
                    },
                    {
                      name = '@vue/typescript-plugin',
                      location = vue_typescript_plugin,
                      languages = { 'vue' },
                      configNamespace = 'typescript',
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = 'always' },
                suggest = {
                  completeFunctionCalls = true,
                },
              },
            },
          },
          angularls = {
            root_dir = function(...)
              return require('lspconfig.util').root_pattern('angular.json', 'nx.json')(...)
            end,
          },
          volar = {
            init_options = {
              vue = {
                hybridMode = true,
              },
            },
            ---@diagnostic disable-next-line: assign-type-mismatch
            root_dir = function(...)
              return require('lspconfig.util').root_pattern('vue.config.json', 'package.json')(...)
            end,
          },
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
            settings = {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                },
                workspace = {
                  checkThirdParty = false,
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
      }
    end,
    setup = {
      ts_ls = function()
        return true
      end,
      angularls = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
              if client.name == 'angularls' then
                --HACK: disable angular renaming capability due to duplicate rename popping up
                client.server_capabilities.renameProvider = false
              end
            end
          end,
        })
      end,
      vtsls = function(_, opts)
        opts.settings.javascript =
          vim.tbl_deep_extend('force', {}, opts.settings.typescript, opts.settings.javascript or {})
      end,
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
        'bash-language-server',
        'gopls',
        'golangci-lint-langserver',
        'rust-analyzer',
        'python-lsp-server',
        'solargraph',
        'yaml-language-server',
        'gitlab-ci-ls',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'nginx-language-server',
        'taplo',
        'sqls',
        'json-lsp',
        'vtsls',
        'typescript-language-server',
        'angular-language-server',
        'vue-language-server',
        'tailwindcss-language-server',
        'css-variables-language-server',
        'emmet-language-server',
        'stylelint-lsp',
        'eslint-lsp',
        'html-lsp',
        'css-lsp',
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
