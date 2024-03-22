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
    'glepnir/galaxyline.nvim',
    event = 'VeryLazy',
    config = function()
      local gls = require('galaxyline').section
      local icon = require('config')
      local devicons = require('nvim-web-devicons')
      local colors = require('solarized-osaka.colors').default

      local function get_current_file_name()
        local file = vim.fn.expand('%:f')
        if vim.fn.empty(file) == 1 then
          return ''
        end
        if vim.bo.modifiable then
          if vim.bo.modified then
            return file .. ' ' .. '' .. ' '
          end
        end
        return file .. '   '
      end
      local function trailing_whitespace()
        local trail = vim.fn.search('\\s$', 'nw')
        if trail ~= 0 then
          return ' '
        else
          return nil
        end
      end

      local buffer_not_empty = function()
        if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
          return true
        end
        return false
      end
      local checkwidth = function()
        local squeeze_width = vim.fn.winwidth(0) / 2
        if squeeze_width > 40 then
          return true
        end
        return false
      end

      gls.left[1] = {
        FirstElement = {
          provider = function()
            return ' '
          end,
          highlight = { colors.blue },
        },
      }
      gls.left[2] = {
        ViMode = {
          separator = ' ',
          provider = function()
            -- auto change color() according the vim mode
            local alias = {
              n = 'NORMAL',
              i = 'INSERT',
              c = 'COMMAND',
              V = 'VISUAL',
              [''] = 'VISUAL',
              v = 'VISUAL',
              ['r?'] = ':CONFIRM',
              rm = '--MORE',
              R = 'REPLACE',
              Rv = 'VIRTUAL',
              s = 'SELECT',
              S = 'SELECT',
              ['r'] = 'HIT-ENTER',
              [''] = 'SELECT',
              t = 'TERMINAL',
              ['!'] = 'SHELL',
            }
            local mode_color = {
              n = colors.green,
              i = colors.blue,
              v = colors.magenta,
              [''] = colors.blue,
              V = colors.blue,
              no = colors.magenta,
              s = colors.orange,
              S = colors.orange,
              [''] = colors.orange,
              ic = colors.yellow,
              cv = colors.red,
              ce = colors.red,
              ['!'] = colors.green,
              t = colors.green,
              c = colors.violet,
              ['r?'] = colors.red,
              ['r'] = colors.red,
              rm = colors.red,
              R = colors.yellow,
              Rv = colors.magenta,
            }
            local vim_mode = vim.fn.mode()
            vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim_mode])
            return alias[vim_mode] .. ' '
          end,
          highlight = { colors.red, 'bold' },
        },
      }

      gls.left[3] = {
        GitIcon = {
          provider = function()
            return ' ' .. devicons.get_icon('git') .. ' '
          end,
          condition = require('galaxyline.provider_vcs').check_git_workspace,
          highlight = { colors.yellow },
        },
      }
      gls.left[4] = {
        GitBranch = {
          separator = '   ',
          provider = 'GitBranch',
          condition = require('galaxyline.provider_vcs').check_git_workspace,
          highlight = { colors.yellow, 'bold' },
        },
      }

      gls.left[5] = {
        FileIcon = {
          provider = 'FileIcon',
          condition = buffer_not_empty,
          highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color },
        },
      }
      gls.left[6] = {
        FileName = {
          separator = ' ',
          provider = { get_current_file_name, 'FileSize', 'FileEncode' },
          condition = buffer_not_empty,
          highlight = { colors.fg, 'bold' },
        },
      }

      gls.left[7] = {
        TrailingWhiteSpace = {
          provider = trailing_whitespace,
          icon = '   ',
          highlight = { colors.yellow },
        },
      }

      gls.left[8] = {
        DiffAdd = {
          provider = 'DiffAdd',
          condition = checkwidth,
          icon = '   ',
          highlight = { colors.green },
        },
      }
      gls.left[9] = {
        DiffModified = {
          provider = 'DiffModified',
          condition = checkwidth,
          icon = '   ',
          highlight = { colors.orange },
        },
      }
      gls.left[10] = {
        DiffRemove = {
          provider = 'DiffRemove',
          condition = checkwidth,
          icon = '   ',
          highlight = { colors.red },
        },
      }

      gls.left[11] = {
        DiagnosticError = {
          provider = 'DiagnosticError',
          icon = icon.icons.diagnostics.Error,
          highlight = { colors.red },
        },
      }
      gls.left[12] = {
        DiagnosticWarn = {
          provider = 'DiagnosticWarn',
          icon = icon.icons.diagnostics.Warn,
          highlight = { colors.yellow },
        },
      }
      gls.left[13] = {
        DiagnosticHint = {
          provider = 'DiagnosticHint',
          icon = icon.icons.diagnostics.Hint,
          highlight = { colors.cyan },
        },
      }
      gls.left[14] = {
        DiagnosticInfo = {
          provider = 'DiagnosticInfo',
          icon = icon.icons.diagnostics.Info,
          highlight = { colors.blue },
        },
      }

      gls.right[1] = {
        LineInfo = {
          provider = 'LineColumn',
          separator_highlight = { colors.blue },
          highlight = { colors.fg },
        },
      }
      gls.right[2] = {
        PerCent = {
          separator = ' | ',
          provider = 'LinePercent',
          separator_highlight = {},
          highlight = { colors.cyan, 'bold' },
        },
      }
      gls.right[3] = {
        LSPClient = {
          separator = ' | ',
          provider = 'GetLspClient',
          separator_highlight = {},
          highlight = { colors.violet, 'bold' },
        },
      }
      gls.right[4] = {
        LastElement = {
          provider = function()
            return ' '
          end,
          highlight = { colors.blue },
        },
      }
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
