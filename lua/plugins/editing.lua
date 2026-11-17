---@type LazySpec
return {
  {
    'nvim-mini/mini.surround',
    event = 'BufRead',
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require('lazy.core.config').spec.plugins['mini.surround']
      local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
      local mappings = {
        { opts.mappings.add, desc = 'Add surrounding' },
        { opts.mappings.delete, desc = 'Delete surrounding' },
        { opts.mappings.replace, desc = 'Replace surrounding' },
        { opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      custom_surroundings = {
        ['b'] = { input = { '%b()', '^.().*().$' }, output = { left = '(', right = ')' } },
        ['B'] = { input = { '%b{}', '^.().*().$' }, output = { left = '{', right = '}' } },
      },
      mappings = {
        add = 'sa',
        delete = 'sd',
        replace = 'sr',
        highlight = '',
        find = '',
        find_left = '',
      },
    },
  },

  {
    'danymat/neogen',
    config = true,
    cmd = { 'Neogen' },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    'RRethy/vim-illuminate',
    event = 'BufRead',
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
      end

      map(']]', 'next')
      map('[[', 'prev')

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', buffer)
          map('[[', 'prev', buffer)
        end,
      })
    end,
  },
}
