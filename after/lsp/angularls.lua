local fs, fn, uv = vim.fs, vim.fn, vim.uv

local function get_angular_core_version(root_dir)
  local package_json = fs.joinpath(root_dir, 'package.json')
  if not uv.fs_stat(package_json) then
    return ''
  end

  local ok, content = pcall(fn.readblob, package_json)
  if not ok or not content then
    return ''
  end

  local json = vim.json.decode(content) or {}

  local version = (json.dependencies or {})['@angular/core']
    or (json.devDependencies or {})['@angular/core']
    or (json.peerDependencies or {})['@angular/core']
    or ''
  return version:match('%d+%.%d+%.%d+') or ''
end

-- structure should be like
-- - $EXTENSION_PATH
--   - @angular
--     - language-server
--       - bin
--         - ngserver
--   - typescript
local function get_global_ls_path()
  local ngserver_exe = fn.exepath('ngserver')
  if #ngserver_exe == 0 then
    return nil
  end

  local realpath = uv.fs_realpath(ngserver_exe) or ngserver_exe
  local extension_path = fs.normalize(fs.joinpath(fs.dirname(realpath), '../../..'))
  return extension_path
end

local function get_local_ls_path(root_dir)
  local extension_path = fs.joinpath(root_dir, 'node_modules')
  if uv.fs_stat(extension_path) then
    return extension_path
  end
  return nil
end

local global_ls_path = get_global_ls_path()

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root_dir = (config and config.root_dir) or fn.getcwd()
    local local_ls_path = get_local_ls_path(root_dir)
    local extension_path = { global_ls_path, local_ls_path }

    local ts_probe_dirs = vim.iter(extension_path):join(',')
    local ng_probe_dirs = vim
      .iter(extension_path)
      :map(function(p)
        return fs.joinpath(p, '@angular/language-server/node_modules')
      end)
      :join(',')

    local cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      ts_probe_dirs,
      '--ngProbeLocations',
      ng_probe_dirs,
      '--angularCoreVersion',
      get_angular_core_version(root_dir),
    }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,

  filetypes = { 'typescript', 'typescriptreact', 'htmlangular' },
  root_markers = { 'angular.json', 'nx.json' },
}
