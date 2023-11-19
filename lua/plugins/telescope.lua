return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    'nvim-telescope/telescope-file-browser.nvim',
  },
  keys = {
    {
      '<C-p>',
      function()
        local builtin = require('telescope.builtin')
        builtin.find_files({
          no_ignore = false,
          hidden = true,
        })
      end,
      desc = 'Lists files in your current working directory, respects .gitignore',
    },
    {
      '<Leader>r',
      function()
        local builtin = require('telescope.builtin')
        builtin.live_grep()
      end,
      desc = 'Search for a string in your current working directory and get results live as you type, respects .gitignore',
    },
    {
      '<Leader>s',
      function()
        local builtin = require('telescope.builtin')
        builtin.current_buffer_fuzzy_find({ fuzzy = false, case_mode = 'ignore_case' })
      end,
      desc = 'Search from current buffer',
    },
    {
      '<Leader>b',
      function()
        local builtin = require('telescope.builtin')
        builtin.buffers()
      end,
      desc = 'Lists open buffers',
    },
    {
      '<Leader>t',
      function()
        local builtin = require('telescope.builtin')
        builtin.help_tags()
      end,
      desc = 'Lists available help tags and opens a new window with the relevant help info on <cr>',
    },
    {
      '\\\\',
      function()
        local builtin = require('telescope.builtin')
        builtin.resume()
      end,
      desc = 'Resume the previous telescope picker',
    },
    {
      '<Leader>dl',
      function()
        local builtin = require('telescope.builtin')
        builtin.diagnostics()
      end,
      desc = 'Lists Diagnostics for all open buffers or a specific buffer',
    },
    {
      '<Leader>?',
      function()
        local builtin = require('telescope.builtin')
        builtin.oldfiles()
      end,
      desc = 'Lists recently opened files',
    },
    {
      '<leader>S',
      function()
        local builtin = require('telescope.builtin')
        builtin.treesitter()
      end,
      desc = 'Lists Function names, variables, from Treesitter',
    },
    {
      'sf',
      function()
        local telescope = require('telescope')

        local function telescope_buffer_dir()
          return vim.fn.expand('%:p:h')
        end

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
      end,
      desc = 'Open File Browser with the path of the current buffer',
    },
  },
  config = function(_, opts)
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local fb_actions = require('telescope').extensions.file_browser.actions

    opts.defaults = {
      prompt_prefix = ' ',
      selection_caret = ' ',
      -- open files in the first window that is an actual file.
      -- use the current window if no other window is available.
      get_selection_window = function()
        local wins = vim.api.nvim_list_wins()
        table.insert(wins, 1, vim.api.nvim_get_current_win())
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == '' then
            return win
          end
        end
        return 0
      end,
      wrap_results = true,
      layout_strategy = 'horizontal',
      layout_config = { prompt_position = 'top' },
      sorting_strategy = 'ascending',
      winblend = 0,
      mappings = {
        i = {
          ['<c-t>'] = open_with_trouble,
          ['<a-t>'] = open_selected_with_trouble,
          ['<a-i>'] = find_files_no_ignore,
          ['<a-h>'] = find_files_with_hidden,
          ['<C-Down>'] = actions.cycle_history_next,
          ['<C-Up>'] = actions.cycle_history_prev,
          ['<C-f>'] = actions.preview_scrolling_down,
          ['<C-b>'] = actions.preview_scrolling_up,
        },
        n = {
          ['q'] = actions.close,
        },
      },
    }
    opts.pickers = {
      diagnostics = {
        theme = 'ivy',
        initial_mode = 'normal',
        layout_config = {
          preview_cutoff = 9999,
        },
      },
    }
    opts.extensions = {
      file_browser = {
        theme = 'dropdown',
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          -- your custom insert mode mappings
          ['n'] = {
            -- your custom normal mode mappings
            ['N'] = fb_actions.create,
            ['h'] = fb_actions.goto_parent_dir,
            ['/'] = function()
              vim.cmd('startinsert')
            end,
            ['<C-u>'] = function(prompt_bufnr)
              for i = 1, 10 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            ['<C-d>'] = function(prompt_bufnr)
              for i = 1, 10 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            ['<PageUp>'] = actions.preview_scrolling_up,
            ['<PageDown>'] = actions.preview_scrolling_down,
          },
        },
      },
    }
    telescope.setup(opts)
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('file_browser')
  end,
}
