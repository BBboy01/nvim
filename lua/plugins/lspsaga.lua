return {
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  keys = {
    { '<leader>dc', '<Cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show current line diagnostic' },
    { '<leader>dp', '<Cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'Next diagnostic at current buffer' },
    { '<leader>dn', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'Prev diagnostic at current buffer' },
    { '<leader>o', '<Cmd>Lspsaga outline<CR>', desc = 'Show outline of current buffer' },
    { 'gd', '<Cmd>Lspsaga goto_definition<CR>', desc = 'Goto cursorword definition' },
    { 'gt', '<Cmd>Lspsaga goto_type_definition<CR>', desc = 'Goto cursorword type definition' },
    { 'K', '<Cmd>Lspsaga hover_doc<CR>', desc = 'Show cursorword doc' },
    { 'gr', '<Cmd>Lspsaga finder<CR>', desc = 'Show cursorword finder' },
    { 'gP', '<Cmd>Lspsaga peek_type_definition<CR>', desc = 'Peek cursorword type definition' },
    { 'gp', '<Cmd>Lspsaga peek_definition<CR>', desc = 'Peek cursorword definition' },
    { 'ga', '<Cmd>Lspsaga code_action<CR>', desc = 'Show code action' },
    { '<Leader>n', '<Cmd>Lspsaga rename<CR>', desc = 'Rename cursorword' },
  },
  opts = {
    outline = {
      layout = 'float',
    },
    rename = {
      in_select = false,
    },
  },
}
