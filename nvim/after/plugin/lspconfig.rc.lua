local status, nvim_lsp = pcall(require, 'lspconfig')
if (not status) then return end
local status2, schemastore = pcall(require, 'schemastore')
if (not status2) then return end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>f", "<Cmd>lua vim.lsp.buf.format()<CR>", opts)
end

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
end

local signs = {
  Error = ' ',
  Warn = ' ',
  Info = ' ',
  Hint = ' ',
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local servers = {
  'html',
  'cssls',
  'cssmodules_ls',
  'eslint',
  'emmet_ls',
  'volar',
  'vuels',
  'tailwindcss',
  'bashls',
  'dockerls',
  'luau_lsp',
  'yamlls'
}
for _, server in ipairs(servers) do
  nvim_lsp[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

local schemas = schemastore.json.schemas()
nvim_lsp.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = schemas,
      validate = { enable = true }
    }
  }
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

nvim_lsp.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
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
})

nvim_lsp.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = { 'vim' }
      },
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
        checkThirdParty = false
      },
      completion = {
        callSnippet = 'Replace',
        keywordSnippet = 'Disable',
      },
      telemetry = {
        enable = false,
      },
    }
  }
}

-- TODO: check if exists a node_modules folder here and run npm i otherwise
local languageServerPath = "."
--[[ local cmd = {"ngserver", "--stdio", "--tsProbeLocations", languageServerPath , "--ngProbeLocations", languageServerPath} ]]
local cmd = {"node", languageServerPath.."/node_modules/@angular/language-service/index.js", "--stdio", "--tsProbeLocations", languageServerPath, "--ngProbeLocations", languageServerPath}

nvim_lsp.angularls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = cmd,
    on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
    end,
}
