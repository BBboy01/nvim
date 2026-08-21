---@brief
---
--- https://github.com/microsoft/typescript
---
--- TypeScript is a language for application-scale JavaScript.
--- TypeScript adds optional types to JavaScript that support tools for large-scale JavaScript applications for any browser, for any host, on any OS.
--- TypeScript compiles to readable, standards-based JavaScript.
---
--- `tsc` can be installed via npm `npm install typescript`.
---
--- ### Monorepo support
---
--- `tsc` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
--- This works without the need of spawning multiple instances of `tsc`, saving memory.
---
--- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.

local bin_cache = {} ---@type table<string, string>

---@param root_dir string
---@return string?
local function resolve_bin(root_dir)
  local candidates = {
    vim.fs.joinpath(root_dir, 'node_modules/.bin', 'tsgo'),
    vim.fs.joinpath(root_dir, 'node_modules/.bin', 'tsc'),
    'tsc',
  }

  return vim.iter(candidates):find(function(bin)
    if vim.fn.executable(bin) ~= 1 then
      return false
    end

    local result = vim.system({ bin, '--version' }, { text = true }):wait()
    local version = vim.version.parse(result.stdout or '')
    return result.code == 0 and version and version.major >= 7
  end)
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = bin_cache[(config or {}).root_dir] or 'tsc'
    return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }, { '.git' } }

    local project_root = vim.fs.root(bufnr, root_markers)
    -- We fallback to the current working directory if no project root is found
    local root_dir = project_root or vim.fn.getcwd()
    local bin = bin_cache[root_dir] or resolve_bin(root_dir)
    if not bin then
      vim.notify('tsc: no local tsgo or TypeScript 7.0+ tsc found', vim.log.levels.WARN)
      return
    end

    bin_cache[root_dir] = bin
    on_dir(root_dir)
  end,
}
