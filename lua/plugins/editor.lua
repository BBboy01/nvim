return {
  'LunarVim/bigfile.nvim',

  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    opts = {
      exclude = { 'lazy', 'mason' },
    },
  },

  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      {
        '<C-p>',
        '<Cmd>FzfLua files<CR>',
        desc = 'Lists files in your current working directory, respects .gitignore',
      },
      {
        '<Leader>r',
        '<Cmd>FzfLua live_grep<CR>',
        desc = 'Search for a regexp in your current working directory and get results live as you type, respects .gitignore',
      },
      {
        '<Leader>s',
        '<Cmd>FzfLua lgrep_curbuf<CR>',
        desc = 'Search from current buffer',
      },
      {
        '<Leader>b',
        '<Cmd>FzfLua buffers<CR>',
        desc = 'Lists open buffers',
      },
      {
        '<Leader>t',
        '<Cmd>FzfLua helptags<CR>',
        desc = 'Lists available help tags and opens a new window with the relevant help info on <cr>',
      },
      {
        '\\\\',
        '<Cmd>FzfLua resume<CR>',
        desc = 'Resume the previous fzf-lua picker',
      },
      {
        '<Leader>dl',
        '<Cmd>FzfLua diagnostics_document<CR>',
        desc = 'Lists Diagnostics for current buffer',
      },
      {
        '<Leader>dL',
        '<Cmd>FzfLua diagnostics_workspace<CR>',
        desc = 'Lists Diagnostics for workspace',
      },
      {
        '<Leader>?',
        '<Cmd>FzfLua oldfiles<CR>',
        desc = 'Lists recently opened files',
      },
      {
        'ss',
        '<Cmd>FzfLua lsp_document_symbols<CR>',
        desc = 'Lists Function names, variables, from Treesitter',
      },
    },
    config = function()
      local config = require('fzf-lua.config')
      local actions = require('fzf-lua.actions')
      local img_previewer = { 'chafa', '{file}', '--format=symbols' }

      config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
      config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
      config.defaults.keymap.fzf['ctrl-x'] = 'jump'
      config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
      config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
      config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
      config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'

      require('fzf-lua').setup({
        fzf_colors = true,
        defaults = {
          formatter = 'path.dirname_first',
        },
        files = {
          cwd_prompt = false,
          actions = {
            ['alt-i'] = { actions.toggle_ignore },
            ['alt-h'] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ['alt-i'] = { actions.toggle_ignore },
            ['alt-h'] = { actions.toggle_hidden },
          },
        },
        previewers = {
          builtin = {
            extensions = {
              ['png'] = img_previewer,
              ['jpg'] = img_previewer,
              ['jpeg'] = img_previewer,
              ['gif'] = img_previewer,
              ['webp'] = img_previewer,
            },
            ueberzug_scaler = 'fit_contain',
          },
        },
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend('force', fzf_opts, {
            prompt = ' ',
            winopts = {
              title = ' ' .. vim.trim((fzf_opts.prompt or 'Select'):gsub('%s*:%s*$', '')) .. ' ',
              title_pos = 'center',
            },
          }, {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { '┃', '' },
          },
        },
      })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    keys = function()
      local harpoon = require('harpoon')
      -- local conf = require('telescope.config').values

      -- local function toggle_telescope(harpoon_files)
      --   local file_paths = {}
      --   for _, item in ipairs(harpoon_files.items) do
      --     table.insert(file_paths, item.value)
      --   end
      --   require('telescope.pickers')
      --     .new({}, {
      --       prompt_title = 'Harpoon',
      --       finder = require('telescope.finders').new_table({
      --         results = file_paths,
      --       }),
      --       previewer = conf.file_previewer({}),
      --       sorter = conf.generic_sorter({}),
      --     })
      --     :find()
      -- end

      local keys = {
        {
          '<A-n>',
          function()
            harpoon:list():next()
          end,
          desc = 'Harpoon next buffer',
        },
        {
          '<A-p>',
          function()
            harpoon:list():prev()
          end,
          desc = 'Harpoon prev buffer',
        },
        {
          '<A-a>',
          function()
            harpoon:list():add()
          end,
          desc = 'Harpoon add current buffer',
        },
        {
          '<leader>h',
          function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon list',
        },
        -- {
        --   '<leader>H',
        --   function()
        --     toggle_telescope(harpoon:list())
        --   end,
        --   desc = 'Harpoon list telescope',
        -- },
      }

      for i = 1, 5 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
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

  {
    'stevearc/oil.nvim',
    lazy = false,
    keys = {
      { 'sf', '<CMD>Oil --float<CR>', desc = 'Open File Browser with the path of the current buffer' },
    },
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
      float = {
        max_width = 100,
        preview_split = 'right',
      },
      win_options = {
        wrap = true,
        winblend = 0,
      },
      keymaps = {
        ['<C-c>'] = false,
        ['<C-l>'] = false,
        ['<C-r>'] = 'actions.refresh',
        ['q'] = 'actions.close',
      },
    },
  },

  -- nvim-tree
  {
    'kyazdani42/nvim-tree.lua',
    keys = {
      { '<Space>e', '<Cmd>NvimTreeToggle<CR>', 'Toggle file struct tree' },
    },
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
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      git = {
        ignore = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        debounce_delay = 50,
        icons = { hint = '', info = '', warning = '', error = '' },
      },
    },
  },
}
