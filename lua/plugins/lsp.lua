---@type LazySpec
return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'b0o/schemastore.nvim',
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    opts = function()
      local icons = require('config.icons')

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
              [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
              [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
              [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            },
          },
        },
        ---@type table<string, vim.lsp.Config>
        servers = {
          html = {},
          cssls = {},
          emmet_language_server = {},
          css_variables = {},
          eslint = {},
          stylelint_lsp = {
            settings = {
              stylelint = {
                snippet = { 'css', 'postcss', 'scss' },
                validate = { 'css', 'postcss', 'scss' },
              },
            },
          },
          tailwindcss = {},
          bashls = {},
          dockerls = {},
          docker_compose_language_service = {},
          tombi = {},
          gopls = {},
          golangci_lint_ls = {},
          ty = {},
          ruff = {},
          solargraph = {},
          sqls = {},
          gitlab_ci_ls = {},
          glsl_analyzer = {},
          just = {},
          fish_lsp = {},
          tsc = {},
          vtsls = {
            filetypes = {
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
                      location = vim.fn.stdpath('data')
                        .. '/mason/packages/angular-language-server/node_modules/@angular/language-server',
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                    {
                      name = '@vue/typescript-plugin',
                      location = vim.fn.stdpath('data')
                        .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
                      languages = { 'vue' },
                      configNamespace = 'typescript',
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                  },
                },
              },
              javascript = {
                updateImportsOnFileMove = { enabled = 'always' },
                suggest = {
                  completeFunctionCalls = true,
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
            on_attach = function(client, _)
              client.server_capabilities.documentFormattingProvider = nil
            end,
          },
          jsonls = {
            settings = {
              json = {
                validate = { enable = true },
                schemas = require('schemastore').json.schemas(),
              },
            },
          },
          yamlls = {
            settings = {
              yaml = {
                validate = true,
                schemaStore = {
                  enable = false,
                  url = '',
                },
                schemas = require('schemastore').yaml.schemas(),
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
                runtime = { version = 'LuaJIT' },
                workspace = {
                  checkThirdParty = false,
                },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
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
          :filter(function(server)
            return not server == 'stylelint_lsp'
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
        'ty',
        'ruff',
        'solargraph',
        'yaml-language-server',
        'gitlab-ci-ls',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'tombi',
        'sqls',
        'json-lsp',
        'vtsls',
        'tsc',
        'angular-language-server',
        'vue-language-server',
        'tailwindcss-language-server',
        'css-variables-language-server',
        'emmet-language-server',
        'stylelint-language-server',
        'eslint-lsp',
        'html-lsp',
        'css-lsp',
        'glsl_analyzer',
        'fish-lsp',
        'just-lsp',
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

  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    keys = {
      { '<C-w><C-d>', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show current line diagnostic' },
      { '<C-w>d', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show current line diagnostic' },
      { ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'Show current line diagnostic' },
      { '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'Show current line diagnostic' },
      {
        '[e',
        function()
          require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = 'Prev error diagnostic at current buffer',
      },
      {
        ']e',
        function()
          require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = 'Next error diagnostic at current buffer',
      },
      { '<leader>o', '<Cmd>Lspsaga outline<CR>', desc = 'Show outline of current buffer' },
      { 'gd', '<Cmd>Lspsaga goto_definition<CR>', desc = 'Goto cursorword definition' },
      { 'grt', '<Cmd>Lspsaga goto_type_definition<CR>', desc = 'Goto cursorword type definition' },
      { 'K', '<Cmd>Lspsaga hover_doc<CR>', desc = 'Show cursorword doc' },
      { 'grr', '<Cmd>Lspsaga finder<CR>', desc = 'Show cursorword finder' },
      { 'gP', '<Cmd>Lspsaga peek_type_definition<CR>', desc = 'Peek cursorword type definition' },
      { 'gp', '<Cmd>Lspsaga peek_definition<CR>', desc = 'Peek cursorword definition' },
      { 'gra', '<Cmd>Lspsaga code_action<CR>', desc = 'Show code action' },
      { 'grn', '<Cmd>Lspsaga rename<CR>', desc = 'Rename cursorword' },
    },
    opts = {
      outline = {
        layout = 'float',
      },
      rename = {
        in_select = false,
      },
    },
  },
}
