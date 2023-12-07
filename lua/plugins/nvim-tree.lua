return {
  'kyazdani42/nvim-tree.lua',
  opts = {
    hijack_netrw = false,
    sort = {
      sorter = 'case_sensitive',
    },
    view = {
      adaptive_size = true,
      float = {
        enable = true,
        open_win_config = {
          col = 999,
        },
      },
    },
    update_focused_file = {
      enable = true,
    },
    renderer = {
      group_empty = true,
      indent_markers = { enable = true },
      icons = {
        git_placement = 'after',
        glyphs = {
          git = {
            unstaged = '~',
            staged = '✓',
            unmerged = '',
            renamed = '+',
            untracked = '?',
            deleted = '',
            ignored = ' ',
          },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      debounce_delay = 50,
      icons = { hint = '', info = '', warning = '', error = '' },
    },
  },
  keys = {
    { '<Space>e', '<Cmd>NvimTreeToggle<CR>', 'Toggle file struct tree' },
  },
}
