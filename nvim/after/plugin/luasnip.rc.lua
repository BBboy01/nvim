local status, ls = pcall(require, "luasnip")
if not status then return end

local types = require("luasnip.util.types")

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip").config.setup({ store_selection_keys = "<A-p>" })

vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]])

ls.config.set_config({
  history = true, -- Keep around last snippet local to jump back
  updateevents = "TextChanged,TextChangedI", -- If you have dynamic snippets, it updates as you type
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        -- virt_text = { { "●", "GruvboxOrange" } },
        virt_text = { { " « ", "NonTest" } }
      },
    },
  },
})

-- Create snippet: s(context, nodes, condition, ...)
local s = ls.s
local i = ls.insert_node
local t = ls.text_node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep


vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable() then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<A-y>", "<Esc>o", { silent = true })

vim.keymap.set({ "i", "s" }, "<a-k>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<a-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<a-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  else
    -- print current time
    local od = os.date("*t")
    local time = string.format("%02d:%02d:%02d", od.hour, od.min, od.sec)
    print(time)
  end
end)
vim.keymap.set({ "i", "s" }, "<a-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

ls.add_snippets(nil, {
  s({ trig = "date" }, {
    f(function()
      return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date())
    end, {}),
  }),
})

-- vim.keymap.set("n", "<Leader><CR>", "<cmd>LuaSnipEdit<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.rc.lua<CR>")
