local status, mason = pcall(require, "mason")
if (not status) then return end

local status2, lspconfig = pcall(require, "mason-lspconfig")
if (not status2) then return end

mason.setup()

lspconfig.setup {
  ensure_installed = {
    "html",
    "cssls",
    "cssmodules_ls",
    "eslint",
    "jsonls",
    "emmet_ls",
    "volar",
    "vuels",
    "angularls@15.2.1",
    "rust_analyzer",
    "tailwindcss",
    "bashls",
    "dockerls",
    "luau_lsp",
    "yamlls",
    "tsserver",
    "lua_ls",
  },
}
