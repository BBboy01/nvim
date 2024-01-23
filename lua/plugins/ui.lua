return {
  -- better vim.ui
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },

  -- tabs, which include filetype icons and close buttons.
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { 'te', '<Cmd>tabedit<CR>', desc = 'Create a new tab' },
      { 'tn', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { 'tp', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { 'to', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete other buffers' },
    },
    ---@type bufferline.UserConfig
    opts = {
      options = {
        mode = 'tabs',
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require('config').icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
            .. (diag.warning and icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd('BufAdd', {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>gb',
        function()
          require('gitsigns').blame_line({ full = true })
        end,
        'Blame current line',
      },
      { '<leader>g[', '<Cmd>Gitsigns prev_hunk<CR>', 'Prev hunk' },
      { '<leader>g]', '<Cmd>Gitsigns next_hunk<CR>', 'Next hunk' },
      { '<leader>gp', '<Cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
      { '<leader>gd', '<Cmd>Gitsigns diff_this<CR>', 'Diff this' },
      { '<leader>gs', '<Cmd>Gitsigns stage_hunk<CR>', 'Stage hunk', { mode = { 'n', 'v' } } },
      { '<leader>gr', '<Cmd>Gitsigns reset_hunk<CR>', 'Reset hunk', { mode = { 'n', 'v' } } },
      { '<leader>gu', '<Cmd>Gitsigns undo_stage_hunk<CR>', 'Undo stage hunk' },
      { '<leader>gS', '<Cmd>Gitsigns stage_buffer<CR>', 'Stage buffer' },
      { '<leader>gR', '<Cmd>Gitsigns reset_buffer<CR>', 'Undo stage buffer' },
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

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        options = {
          icons_enabled = true,
          theme = 'solarized_dark',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = {},
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = {
                error = ' ',
                warn = ' ',
                info = ' ',
                hint = ' ',
              },
            },
            'encoding',
            'filetype',
            'filesize',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'fugitive' },
      }
    end,
  },

  -- indent guides
  {
    'nvimdev/indentmini.nvim',
    event = 'BufEnter',
    config = function()
      require('indentmini').setup({
        char = '|',
      })
    end,
  },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },

  -- ui components
  { 'MunifTanjim/nui.nvim', lazy = true },

  -- icons
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- rainbow bracket
  {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = true,
    event = 'BufRead',
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterBlue',
          'RainbowDelimiterYellow',
          'RainbowDelimiterCyan',
          'RainbowDelimiterViolet',
          'RainbowDelimiterRed',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
        },
      }
    end,
  },

  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function()
      local logo = [[
        ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗        Z
        ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗     Z  
        ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝   z    
        ██╔══██║  ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗ z      
        ██║  ██║   ██║   ██████╔╝███████╗██║  ██║        
        ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝        
      ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'

      local opts = {
        theme = 'doom',
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, '\n'),
          -- stylua: ignore
          center = {
            { action = function()
              require('telescope.builtin').find_files({
                no_ignore = false,
                hidden = true,
              })
            end, desc = " Find file", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
        button.key_format = '  %s'
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },
}
