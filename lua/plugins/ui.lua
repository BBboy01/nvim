---@type LazySpec
return {
  -- tabs, which include filetype icons and close buttons.
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { 'te', '<Cmd>tabedit<CR>', desc = 'Create a new tab' },
      { 'tn', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
      { 'tp', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
      { 'to', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete other buffers' },
      { 'ts', '<Cmd>BufferLinePick<CR>', desc = 'Pick buffers' },
    },
    ---@type bufferline.UserConfig
    opts = {
      options = {
        mode = 'tabs',
        show_buffer_icons = true,
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
      { '<leader>gd', '<Cmd>Gitsigns diffthis<CR>', 'Diff this' },
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
      local lualine_require = require('lualine_require')
      lualine_require.require = require

      local icons = require('config').icons
      local colors = require('solarized-osaka.colors').default

      local opts = {
        options = {
          disabled_filetypes = { statusline = { 'dashboard' } },
          component_separators = '',
          section_separators = '',
          theme = {
            normal = { c = { fg = colors.fg, bg = 'NONE' } },
          },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {
            {
              'mode',
              color = function()
                local mode_color = {
                  n = colors.green,
                  i = colors.blue,
                  v = colors.magenta,
                  [''] = colors.blue,
                  V = colors.blue,
                  c = colors.violet,
                  no = colors.magenta,
                  s = colors.orange,
                  S = colors.orange,
                  [''] = colors.orange,
                  ic = colors.yellow,
                  R = colors.yellow,
                  Rv = colors.magenta,
                  cv = colors.red,
                  ce = colors.red,
                  r = colors.red,
                  rm = colors.red,
                  ['r?'] = colors.red,
                  ['!'] = colors.green,
                  t = colors.green,
                }
                return { fg = mode_color[vim.fn.mode()] }
              end,
            },
            { 'branch', color = { fg = colors.yellow } },
            { 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
            {
              function()
                local file = vim.fn.expand('%:f')
                if vim.fn.empty(file) == 1 then
                  return ''
                end
                return file
              end,
            },
            { 'filesize' },
            { 'encoding' },
            {
              'diagnostics',
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_x = {
            {
              'diff',
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              padding = { left = 0, right = 2 },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            { 'location', padding = { left = 0, right = 1 } },
            { 'progress', separator = ' ', padding = { left = 0, right = 1 }, color = { fg = colors.cyan } },
            { 'lsp_status', color = { fg = colors.violet } },
          },
        },
      }

      return opts
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
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
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
    },
  },

  -- ui components
  { 'MunifTanjim/nui.nvim', lazy = true },

  -- icons
  {
    'echasnovski/mini.icons',
    lazy = true,
    opts = {
      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
      },
      file = {
        ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

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
          center = {
            {
              action = function()
                require('fzf-lua').files()
              end,
              desc = ' Find file',
              icon = ' ',
              key = 'f',
            },
            { action = 'ene | startinsert', desc = ' New file', icon = ' ', key = 'n' },
            {
              action = function()
                require('fzf-lua').oldfiles()
              end,
              desc = ' Recent files',
              icon = ' ',
              key = 'r',
            },
            {
              action = function()
                require('fzf-lua').grep_project()
              end,
              desc = ' Find text',
              icon = ' ',
              key = 'g',
            },
            { action = 'lua require("persistence").load()', desc = ' Restore Session', icon = ' ', key = 's' },
            {
              action = function()
                vim.cmd.lcd(vim.env.XDG_CONFIG_HOME .. '/nvim')
                require('fzf-lua').files()
              end,
              desc = ' Config',
              icon = ' ',
              key = 'c',
            },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
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
