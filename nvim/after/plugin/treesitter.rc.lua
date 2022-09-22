local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    'javascript',
    'typescript',
    'dockerfile',
    'gitignore',
    'dot',
    'tsx',
    'vue',
    'fish',
    'yaml',
    'lua',
    'json',
    'css',
    'scss',
    'html'
  },
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
    disable = {},
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil,
    colors = { "#845EC2", "#4FFBDF", "#2265DC", "#FF8066", "#229900", "#999900", "#FFC75F", "#EE66E8" }, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript", "typescript.tsx" }
