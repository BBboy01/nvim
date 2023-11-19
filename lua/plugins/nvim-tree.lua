return {
  'kyazdani42/nvim-tree.lua',
  commit = '086bf310bd19a7103ee7d761eb59f89f3dd23e21',
  opts = function()
    return {
      hijack_netrw = false,
      sort_by = 'case_sensitive',
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = 'P', action = 'cd' },
            { key = '<BS>', action = 'dir_up' },
            { key = 'l', action = 'expand' },
            { key = 'h', action = 'close_node' },
            { key = '>', action = 'next_git_item' },
            { key = '<', action = 'prev_git_item' },
            { key = '?', action = 'toggle_help' },
            { key = 'N', action = 'create' },
          },
        },
        float = {
          enable = true,
          open_win_config = {
            border = 'rounded',
            width = 30,
            height = 20,
            row = 0,
            col = 999,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
      renderer = {
        group_empty = true,
        indent_markers = { enable = true },
        icons = {
          git_placement = 'after',
          webdev_colors = true,
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
      filters = { dotfiles = true },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        debounce_delay = 50,
        icons = { hint = '', info = '', warning = '', error = '' },
      },
    }
  end,
  config = function(_, opts)
    require('nvim-tree').setup(opts)
    vim.keymap.set('n', ' e', '<Cmd>NvimTreeToggle<cr>')
  end,
}
