---@type LazySpec
return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    keys = {
      {
        '<leader>gb',
        function()
          require('gitsigns').blame_line({ full = true })
        end,
        desc = 'Blame current line',
      },
      { '<leader>g[', '<Cmd>Gitsigns prev_hunk<CR>', desc = 'Previous hunk' },
      { '<leader>g]', '<Cmd>Gitsigns next_hunk<CR>', desc = 'Next hunk' },
      { '<leader>gp', '<Cmd>Gitsigns preview_hunk<CR>', desc = 'Preview hunk' },
      { '<leader>gd', '<Cmd>Gitsigns diffthis<CR>', desc = 'Diff this' },
      { '<leader>gr', '<Cmd>Gitsigns reset_hunk<CR>', desc = 'Reset hunk' },
      { '<leader>gR', '<Cmd>Gitsigns reset_buffer<CR>', desc = 'Reset buffer' },
    },
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

  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit' },
    keys = {
      { '<space>g', '<Cmd>LazyGit<cr>', desc = 'Open lazy git' },
    },
  },
}
