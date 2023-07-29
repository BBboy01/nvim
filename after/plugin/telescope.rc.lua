local status, telescope = pcall(require, 'telescope')
if not status then
  return
end
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require('telescope').extensions.file_browser.actions

telescope.setup({
  defaults = {
    mappings = {
      n = {
        ['q'] = actions.close,
      },
    },
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      media_files = {
        -- filetypes whitelist
        -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'mp4', 'pdf' },
        find_cmd = 'rg', -- find command (defaults to `fd`)
      },
      mappings = {
        ['i'] = {
          ['<C-w>'] = function()
            vim.cmd('normal vbd')
          end,
        },
        ['n'] = {
          ['N'] = fb_actions.create,
          ['h'] = fb_actions.goto_parent_dir,
          ['H'] = fb_actions.toggle_respect_gitignore,
        },
      },
    },
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})

telescope.load_extension('file_browser')
telescope.load_extension('fzy_native')

vim.keymap.set('n', '<Leader>r', function()
  builtin.live_grep()
end, { desc = 'Search content from hole project' })

vim.keymap.set('n', '<Leader>s', function()
  builtin.current_buffer_fuzzy_find({ fuzzy = false, case_mode = 'ignore_case' })
end, { desc = 'Search from current buffer' })

vim.keymap.set('n', '<Leader>t', function()
  builtin.help_tags()
end, { desc = 'Search help' })

vim.keymap.set('n', '\\\\', function()
  builtin.resume()
end, { desc = 'Resume buffers' })
vim.keymap.set('n', '<Leader>b', function()
  builtin.buffers()
end, { desc = 'Show existing buffers' })

vim.keymap.set('n', '<Leader>dl', function()
  builtin.diagnostics()
end, { desc = 'Search diagnostics from current project' })

vim.keymap.set('n', '<C-p>', function()
  builtin.find_files({
    no_ignore = false,
    hidden = true,
  })
end, { desc = 'Search file from hole project' })
vim.keymap.set('n', '<Leader>?', function()
  builtin.oldfiles()
end, { desc = 'Find recently opened files' })
vim.keymap.set('n', 'sf', function()
  telescope.extensions.file_browser.file_browser({
    path = '%:p:h',
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = 'normal',
    layout_config = { height = 40 },
  })
end, { desc = 'Search files from current path' })
