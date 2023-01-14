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
    "angularls",
    "tailwindcss",
    "bashls",
    "dockerls",
    "luau_lsp",
    "yamlls",
    "tsserver",
    "sumneko_lua",
  },
}
