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
    registers = false,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
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
  ["g"] = {
    ["d"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto definition" },
    ["i"] = { "<cmd>Telescope lsp_implementations<cr>", "Show implementations" },
    ["r"] = { "<cmd>Telescope lsp_references<cr>", "Show references" },
  },

  ["<leader>"] = {
    [","] = { "<cmd>NvimTreeFindFile<cr>", "Find current file" },
    ["."] = { "<cmd>NvimTreeFocus<cr>", "Toggle file tree" },
    ["?"] = { "<cmd>WhichKey<cr>", "Halp!?" },
    ["c"] = { "<cmd>tabclose<cr>", "Close tab (and all panes)" },
    ["cc"] = { "<cmd>cd %:p:h<cr>", "Change dir for all buffers" },
    ["cd"] = { "<cmd>lcd %:p:h<cr>", "Change dir for this buffer" },
    ["h"] = { "<cmd>nohlsearch<cr>", "No Highlight" },
    ["n"] = { "<cmd>tabnext<cr>", "Next tab" },
    ["N"] = { "<cmd>tabprevious<cr>", "Previous tab" },
    ["t"] = { "<cmd>TroubleToggle<cr>", "Show problems" },

    f = {
      name = "Files and buffers",
      ["b"] = {
        "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes'))<cr>",
        "Buffers",
      },
      ["f"] = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        "Find files",
      },
      ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
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
