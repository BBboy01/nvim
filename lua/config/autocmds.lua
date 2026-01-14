local group = vim.api.nvim_create_augroup('hyber', { clear = true })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = group,
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = group,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = {
    'PlenaryTestPopup',
    'help',
    'man',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'dbout',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = event.buf, silent = true, desc = 'Quit buffer' })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = group,
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Disable most features for bigfile
local opts = {
  notify = true, -- show notification when big file detected
  size = 1.5 * 1024 * 1024, -- 1.5MB
  line_length = 1000, -- average line length (useful for minified files)
  -- Enable or disable features when big file detected
  ---@param ctx {buf: number, ft:string}
  setup = function(ctx)
    if vim.fn.exists(':NoMatchParen') ~= 0 then
      vim.cmd([[NoMatchParen]])
    end
    for k, v in pairs({ foldmethod = 'manual', statuscolumn = '', conceallevel = 0 }) do
      if k == 'winhighlight' and type(v) == 'table' then
        local parts = {} ---@type string[]
        for kk, vv in pairs(v) do
          if vv ~= '' then
            parts[#parts + 1] = ('%s:%s'):format(kk, vv)
          end
        end
        v = table.concat(parts, ',')
      end
      vim.api.nvim_set_option_value(k, v, { scope = 'local', win = 0 })
    end
    vim.b.completion = false
    vim.b.minianimate_disable = true
    vim.b.minihipatterns_disable = true
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        vim.bo[ctx.buf].syntax = ctx.ft
      end
    end)
  end,
}
vim.filetype.add({
  pattern = {
    ['.*'] = {
      function(path, buf)
        if not path or not buf or vim.bo[buf].filetype == 'bigfile' then
          return
        end
        if path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) then
          return
        end
        local size = vim.fn.getfsize(path)
        if size <= 0 then
          return
        end
        if size > opts.size then
          return 'bigfile'
        end
        local lines = vim.api.nvim_buf_line_count(buf)
        return (size - lines) / lines > opts.line_length and 'bigfile' or nil
      end,
    },
  },
})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = 'bigfile',
  callback = function(ev)
    if opts.notify then
      local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ':p:~:.')
      vim.api.nvim_echo({
        { ' Big File ', 'DiagnosticVirtualTextWarn' },
        { 'Big file detected ' },
        { path, 'DiagnosticVirtualTextInfo' },
        { '. ' },
        { 'Some Neovim features have been ' },
        { 'disabled', 'WarningMsg' },
        { '.' },
      }, true, {})
    end
    vim.api.nvim_buf_call(ev.buf, function()
      opts.setup({
        buf = ev.buf,
        ft = vim.filetype.match({ buf = ev.buf }) or '',
      })
    end)
  end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  group = group,
  command = 'set nopaste',
})
