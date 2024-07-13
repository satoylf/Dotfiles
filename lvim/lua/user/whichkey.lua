lvim.builtin.which_key.setup.plugins.presets["operators"] = false
lvim.builtin.which_key.setup.ignore_missing = true

lvim.builtin.which_key.mappings['T'] = {}
lvim.builtin.which_key.mappings['h'] = {}
lvim.builtin.which_key.mappings['g'] = {}
lvim.builtin.which_key.mappings["b"] = { "<cmd>Telescope buffers<cr>", "Buffers" }
lvim.builtin.which_key.mappings["v"] = { "<cmd>vsplit<cr>", "vsplit" }
lvim.builtin.which_key.mappings["q"] = { '<cmd>lua require("user.functions").smart_quit()<CR>', "Quit" }
lvim.builtin.which_key.mappings["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" }
lvim.builtin.which_key.mappings["w"] = { '<cmd>w!<CR>', "Save" }
-- lvim.builtin.which_key.mappings["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" }
lvim.builtin.which_key.mappings["d"] = {
  name = "Debug",
  b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
  c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
  o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
  O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
  r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
  l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
  u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
  x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
}
lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  f = { "<cmd>Telescope find_files<cr>", "Find files" },
  t = { "<cmd>Telescope live_grep<cr>", "Find Text" },
  s = { "<cmd>Telescope grep_string<cr>", "Find String" },
  r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
}

lvim.builtin.which_key.mappings["t"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Terminal" }

-- lvim.builtin.cmp.enabled = false
-- lvim.builtin.which_key.mappings["o"] = {
--   name = "Options",
--   c = { "<cmd>lua lvim.builtin.cmp.active = false<cr>", "Completion off" },
--   C = { "<cmd>lua lvim.builtin.cmp.active = true<cr>", "Completion on" },
--   -- w = { '<cmd>lua require("user.functions").toggle_option("wrap")<cr>', "Wrap" },
--   -- r = { '<cmd>lua require("user.functions").toggle_option("relativenumber")<cr>', "Relative" },
--   -- l = { '<cmd>lua require("user.functions").toggle_option("cursorline")<cr>', "Cursorline" },
--   -- s = { '<cmd>lua require("user.functions").toggle_option("spell")<cr>', "Spell" },
--   -- t = { '<cmd>lua require("user.functions").toggle_tabline()<cr>', "Tabline" },
-- }
lvim.builtin.which_key.mappings[";"] = nil
-- lvim.builtin.which_key.mappings["c"] = nil
lvim.builtin.which_key.mappings["L"] = nil
lvim.builtin.which_key.mappings["s"] = nil

local m_opts = {
  mode = "n",     -- NORMAL mode
  prefix = "m",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end
