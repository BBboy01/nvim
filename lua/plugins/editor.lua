local Util = require('util')

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { " s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S",  mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  {
    'echasnovski/mini.hipatterns',
    event = 'BufReadPre',
    opts = {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
      },
    },
    config = function(_, opts)
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup(vim.tbl_deep_extend('force', opts, {
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
          -- Highlight hsl color call (`hsl(0, 0, 0)`) using that color
          hsl_color = {
            pattern = 'hsl%(%d+,? %d+,? %d+%)',
            group = function(_, match)
              local utils = require('solarized-osaka.hsl')
              --- @type string, string, string
              local nh, ns, nl = match:match('hsl%((%d+),? (%d+),? (%d+)%)')
              --- @type number?, number?, number?
              local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
              --- @type string
              local hex_color = utils.hslToHex(h, s, l)
              return hipatterns.compute_hex_color_group(hex_color, 'bg')
            end,
          },
        },
      }))
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function()
          Util.on_load('telescope.nvim', function()
            require('telescope').load_extension('fzf')
          end)
        end,
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
          builtin.diagnostics({ bufnr = 0 })
        end,
        desc = 'Lists Diagnostics for current buffer',
      },
      {
        '<Leader>da',
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
        'ss',
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
              ['<C-u>'] = function(prompt_bufnr)
                for _ = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ['<C-d>'] = function(prompt_bufnr)
                for _ = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
          },
        },
      }
      telescope.setup(opts)
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('file_browser')
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

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    'RRethy/vim-illuminate',
    event = 'BufRead',
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
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require('statuscol.builtin')
          require('statuscol').setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            },
          })
        end,
      },
    },
    event = 'BufReadPost',
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    },
    keys = {
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
      },
    },
    init = function()
      vim.o.foldcolumn = '1'
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.o.foldenable = false
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
    end,
  },
}
