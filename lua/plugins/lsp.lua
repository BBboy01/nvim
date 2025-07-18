---@type LazySpec
return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    opts = function()
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
        servers = {
          html = {},
          cssls = {},
          emmet_language_server = {},
          css_variables = {},
          eslint = {},
          stylelint_lsp = {},
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
          glsl_analyzer = {},
          fish_lsp = {},
          ts_ls = {},
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
                tsserver = {
                  globalPlugins = {
                    {
                      name = '@angular/language-server',
                      location = vim.fn.expand(
                        '$MASON/packages/angular-language-server/node_modules/@angular/language-server'
                      ),
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                    {
                      name = '@vue/typescript-plugin',
                      location = vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server'),
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
          angularls = {},
          vue_ls = {
            on_init = function(client)
              client.handlers['tsserver/request'] = function(_, result, context)
                local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
                if #clients == 0 then
                  vim.notify(
                    'Could not found `vtsls` lsp client, vue_lsp would not work without it.',
                    vim.log.levels.ERROR
                  )
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = 'vue forward request',
                  command = 'typescript.tsserverRequest',
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response_data = { { id, (r or {}).body } }
                  client:notify('tsserver/response', response_data)
                end)
              end
            end,
            on_attach = function(client, _)
              client.server_capabilities.documentFormattingProvider = nil
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
      -- setup diagnostics signs
      opts.diagnostics.virtual_text.prefix = function(diagnostic)
        return opts.diagnostics.signs.text[diagnostic.severity]
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      require('mason-lspconfig').setup({
        automatic_enable = {
          exclude = {
            'ts_ls',
          },
        },
        ensure_installed = vim
          .iter(opts.servers)
          :map(function(server, server_opts)
            vim.lsp.config(server, server_opts)
            return server
          end)
          :totable(),
      })
    end,
  },

  {
    'mason-org/mason.nvim',
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
        'glsl_analyzer',
        'fish-lsp',
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
