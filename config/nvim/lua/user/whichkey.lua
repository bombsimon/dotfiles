-- i can't let go of shift
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wa", "wa", {})

-- resize windows
vim.keymap.set("n", "<C-h>", "<cmd>vertical resize -5<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>vertical resize +5<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>resize -5<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>resize +5<cr>")

local which_key = require("which-key")

local opts = {
  prefix = "",
}

local setup = {
  plugins = {
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 10,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
}

local mappings = {
  ["<C-b>"] = { "<C-b>", "Up 1 page" },
  ["<C-d>"] = { "<C-d>", "Up ½ page" },
  ["<C-e>"] = { "<C-e>", "Show diagnostic" },
  ["<C-f>"] = { "<C-f>", "Down 1 page" },
  ["<C-q>"] = { "<C-q>", "Hover actions" },
  ["<C-u>"] = { "<C-u>", "Down ½ page" },

  ["{"] = { "{", "Previous symbol" },
  ["}"] = { "}", "Next symbol" },

  g = {
    d = { "<cmd>Telescope lsp_definitions<cr>", "Goto definition" },
    i = { "<cmd>Telescope lsp_implementations<cr>", "Show implementations" },
    r = { "<cmd>Telescope lsp_references<cr>", "Show references" },
  },
  ["<leader>"] = {
    [","] = { "<cmd>NvimTreeFindFile | NvimTreeFocus<cr>", "Find and focus current file" },
    ["."] = { "<cmd>NvimTreeToggle<cr>", "Toggle file tree" },
    ["?"] = { "<cmd>WhichKey<cr>", "Halp!?" },
    a = { "<cmd>AerialToggle!<cr>", "Toggle Aerial" },
    h = { "<cmd>nohlsearch<cr>", "No Highlight" },
    n = { "<cmd>tabnext<cr>", "Next tab" },
    N = { "<cmd>tabprevious<cr>", "Previous tab" },
    t = { "<cmd>TroubleToggle<cr>", "Show problems" },

    c = {
      name = "Quickfix and navigation",
      a = { "<cmd>cd %:p:h<cr>", "Change dir for all buffers" },
      d = { "<cmd>lcd %:p:h<cr>", "Change dir for this buffer" },
      c = { "<cmd>cclose<cr>", "Close quickfix" },
      n = { "<cmd>cnext<cr>", "Go to next quickfix item" },
      o = { "<cmd>copen<cr>", "Open quickfix" },
      p = { "<cmd>cprevious<cr>", "Go to next quickfix item" },
      t = { "<cmd>tabclose<cr>", "Close tab (and all panes)" },
    },

    d = {
      name = "Debugger",
      b = { '<cmd>DapToggleBreakpoint<cr>', 'Breakpoint' },
      g = { '<cmd>lua require("dap-go").debug_test()<cr>', 'Debug Go test' },
      j = { '<cmd>DapStepInto <cr>', 'Step Into' },
      k = { '<cmd>DapStepOut <cr>', 'Step Out' },
      l = { '<cmd>DapStepOver<CR>', 'Step Over' },
      t = { '<cmd>DapTerminate<cr>', 'Terminate' },
      T = { '<cmd>:lua require("dap-go").debug_test()<cr>', 'Debug Go test' },
      c = { '<cmd>DapContinue<cr>', 'Continue' },
      C = { '<cmd>lua require("dapui").close()<cr>', 'Close DAP UI' },
      O = { '<cmd>lua require("dapui").open()<cr>', 'Open DAP UI' },
    },

    f = {
      name = "Files and buffers",
      b = {
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "Buffers",
      },
      f = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<cr>",
        "Find files",
      },
      i = {
        "<cmd>lua require('telescope.builtin').grep_string(require('telescope.themes').get_dropdown())<cr>",
        "Grep string",
      },
      F = { "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", "Find Text" },
    },

    g = {
      name = "Git",
      j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        "Undo Stage Hunk",
      },
      o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
      d = {
        "<cmd>Gitsigns diffthis HEAD<cr>",
        "Diff",
      },
    },

    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = {
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        "Document Diagnostics",
      },
      w = {
        "<cmd>Telescope diagnostics<cr>",
        "Workspace Diagnostics",
      },
      f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      j = {
        "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",
        "Next Diagnostic",
      },
      k = {
        "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
        "Prev Diagnostic",
      },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      },
    },

    p = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    s = {
      name = "Search",
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
      h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
      M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      R = { "<cmd>Telescope registers<cr>", "Registers" },
      k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
      C = { "<cmd>Telescope commands<cr>", "Commands" },
    },
    v = { "<cmd>WhichKey '' v<cr>", "Show visual maps" },
  },
}

which_key.setup(setup)
which_key.register(mappings, opts)
