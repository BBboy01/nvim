return {
  {
    'dinhhuy258/git.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        keymaps = {
          -- Open blame window
          blame = '<leader>gb',
          -- Open file/folder in git repository
          browse = '<leader>go',
        },
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┃' },
      },
    },
  },
}
