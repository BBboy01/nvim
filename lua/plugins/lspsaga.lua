return {
  'nvimdev/lspsaga.nvim',
  event = 'VeryLazy',
  opts = function()
    return {
      ui = {
        title = true,
        border = 'rounded',
        winblend = 0,
        expand = '',
        collapse = '',
        code_action = '💡',
        preview = ' ',
        diagnostic = '🐞',
        incoming = ' ',
        outgoing = ' ',
        colors = {
          red = '#e95678',
          magenta = '#b33076',
          orange = '#FF8700',
          yellow = '#f7bb3b',
          green = '#afd700',
          cyan = '#36d0e0',
          blue = '#61afef',
          purple = '#CBA6F7',
          white = '#d1d4cf',
          black = '#073642',
        },
        kind = {},
      },
      finder = {
        jump_to = 'p',
        edit = { 'o', '<CR>' },
        vsplit = 'v',
        split = 's',
        tabe = 't',
        quit = { 'q', '<ESC>' },
      },
      definition = {
        edit = '<C-c>o',
        vsplit = '<C-c>v',
        split = '<C-c>s',
        tabe = '<C-c>t',
        quit = 'q',
        close = '<Esc>',
      },
    }
  end,
  config = function(_, opts)
    require('lspsaga').setup(opts)
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>dc', '<Cmd>Lspsaga show_line_diagnostics<cr>', opts)
    vim.keymap.set('n', '<leader>dp', '<Cmd>Lspsaga diagnostic_jump_next<cr>', opts)
    vim.keymap.set('n', '<leader>dn', '<Cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
    vim.keymap.set('n', '<leader>o', '<Cmd>Lspsaga outline<cr>', opts)
    vim.keymap.set('n', '<Leader>ci', '<cmd>Lspsaga incoming_calls<CR>')
    vim.keymap.set('n', '<Leader>co', '<cmd>Lspsaga outgoing_calls<CR>')
    vim.keymap.set({ 'n', 't', 'i' }, '<C-j>', '<cmd>Lspsaga term_toggle<CR>')
    vim.keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<cr>', opts)
    vim.keymap.set('n', 'gt', '<Cmd>Lspsaga goto_type_definition<cr>', opts)
    vim.keymap.set('n', 'gh', '<Cmd>Lspsaga hover_doc<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>', opts)
    vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<cr>', opts)
    vim.keymap.set('n', 'ga', '<Cmd>Lspsaga code_action<cr>', opts)
    vim.keymap.set('n', '<Leader>n', '<Cmd>Lspsaga rename<cr>', opts)
  end,
}
