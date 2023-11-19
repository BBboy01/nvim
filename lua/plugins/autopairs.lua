return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = function()
    return {
      disable_filetype = { 'TelescopePrompt', 'vim' },
    }
  end,
}
