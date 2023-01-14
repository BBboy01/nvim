local status, nvim_lsp = pcall(require, 'lspconfig')
if (not status) then return end
local status2, schemastore = pcall(require, 'schemastore')
if (not status2) then return end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false
    )
  end
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>f", "<Cmd>lua vim.lsp.buf.format()<CR>", opts)
end

local on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)
  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

local servers = {
  'cssmodules_ls',
  'eslint',
  'emmet_ls',
  'volar',
  'vuels',
  'angularls',
  'tailwindcss',
  'bashls',
  'dockerls',
  'luau_lsp',
  'yamlls'
}
for _, server in ipairs(servers) do
  nvim_lsp[server].setup({})
end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup {
  capabilities = capabilities,
}

nvim_lsp.cssls.setup {
  capabilities = capabilities,
}

local schemas = schemastore.json.schemas()
nvim_lsp.jsonls.setup {
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

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the 'vim' global
        globals = { 'vim' }
      },

      workspace = {
        -- Make the server aware of Neovim runtime files
        -- library = vim.api.nvim_get_runtime_file("", true),
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
        checkThirdParty = false
      }
    }
  }
}
