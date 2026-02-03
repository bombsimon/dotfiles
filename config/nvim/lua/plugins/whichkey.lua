return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    -- TODO: Needed?
    "echasnovski/mini.icons",
  },
  opts = {
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
    replace = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
  },
  config = function()
    local function toggle_neotree_git()
      vim.cmd("Neotree git_status toggle")
      vim.opt_local.foldenable = false
    end

    -- i can't let go of shift
    vim.api.nvim_create_user_command("W", "w", {})
    vim.api.nvim_create_user_command("Wa", "wa", {})

    -- resize windows
    vim.keymap.set("n", "<C-h>", "<cmd>vertical resize -5<cr>")
    vim.keymap.set("n", "<C-l>", "<cmd>vertical resize +5<cr>")
    vim.keymap.set("n", "<C-j>", "<cmd>resize -5<cr>")
    vim.keymap.set("n", "<C-k>", "<cmd>resize +5<cr>")

    local wk = require("which-key")
    wk.add({
      { "<C-b>", "<C-b>", desc = "Up 1 page" },
      { "<C-d>", "<C-d>", desc = "Up ½ page" },
      { "<C-e>", "<C-e>", desc = "Show diagnostic" },
      { "<C-f>", "<C-f>", desc = "Down 1 page" },
      { "<C-q>", "<C-q>", desc = "Hover actions" },
      { "<C-u>", "<C-u>", desc = "Down ½ page" },

      { "<leader>,", "<cmd>Neotree reveal<cr>", desc = "Find and focus current file" },
      { "<leader>.", "<cmd>Neotree action=show toggle=true<cr>", desc = "Toggle file tree" },
      { "<leader>>", toggle_neotree_git, desc = "Toggle git changed files" },
      { "<leader>?", "<cmd>WhichKey<cr>", desc = "Halp!?" },
      { "<leader>N", "<cmd>tabprevious<cr>", desc = "Previous tab" },
      { "<leader>a", "<cmd>AerialToggle!<cr>", desc = "Toggle Aerial" },

      { "<leader>c", group = "Quickfix and navigation" },
      { "<leader>ca", "<cmd>cd %:p:h<cr>", desc = "Change dir for all buffers" },
      { "<leader>cc", "<cmd>cclose<cr>", desc = "Close quickfix" },
      { "<leader>cd", "<cmd>lcd %:p:h<cr>", desc = "Change dir for this buffer" },
      { "<leader>cn", "<cmd>cnext<cr>", desc = "Go to next quickfix item" },
      { "<leader>co", "<cmd>copen<cr>", desc = "Open quickfix" },
      { "<leader>cp", "<cmd>cprevious<cr>", desc = "Go to next quickfix item" },
      { "<leader>ct", "<cmd>tabclose<cr>", desc = "Close tab (and all panes)" },

      { "<leader>d", group = "Debugger" },
      { "<leader>dC", '<cmd>lua require("dapui").close()<cr>', desc = "Close DAP UI" },
      { "<leader>dO", '<cmd>lua require("dapui").open()<cr>', desc = "Open DAP UI" },
      {
        "<leader>dT",
        '<cmd>:lua require("dap-go").debug_test()<cr>',
        desc = "Debug Go test",
      },
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<leader>dg", '<cmd>lua require("dap-go").debug_test()<cr>', desc = "Debug Go test" },
      { "<leader>dj", "<cmd>DapStepInto <cr>", desc = "Step Into" },
      { "<leader>dk", "<cmd>DapStepOut <cr>", desc = "Step Out" },
      { "<leader>dl", "<cmd>DapStepOver<CR>", desc = "Step Over" },
      { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },

      { "<leader>f", group = "Files and buffers" },
      {
        "<leader>fF",
        "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
        desc = "Find Text",
      },
      { "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", desc = "Buffers" },
      {
        "<leader>ff",
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<cr>",
        desc = "Find files",
      },
      {
        "<leader>fi",
        "<cmd>lua require('telescope.builtin').grep_string(require('telescope.themes').get_dropdown())<cr>",
        desc = "Grep string",
      },

      { "<leader>g", group = "Git" },
      { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
      { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
      { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
      { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
      { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
      { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
      { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
      { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
      { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },

      { "<leader>h", "<cmd>nohlsearch<cr>", desc = "No Highlight" },

      { "<leader>l", group = "LSP" },
      { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info" },
      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
      { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format" },
      { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
      { "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
      { "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
      { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

      { "<leader>n", "<cmd>tabnext<cr>", desc = "Next tab" },

      { "<leader>p", group = "Packer" },
      { "<leader>pS", "<cmd>PackerStatus<cr>", desc = "Status" },
      { "<leader>pc", "<cmd>PackerCompile<cr>", desc = "Compile" },
      { "<leader>pi", "<cmd>PackerInstall<cr>", desc = "Install" },
      { "<leader>ps", "<cmd>PackerSync<cr>", desc = "Sync" },
      { "<leader>pu", "<cmd>PackerUpdate<cr>", desc = "Update" },

      { "<leader>s", group = "Search" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
      { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },

      { "<leader>v", group = "Virtualenv" },
      {
        "<leader>vc",
        "<cmd>VenvSelectCached<cr>",
        desc = "Select previous Python venv",
      },
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },

      { "<leader>t", "<cmd>TroubleToggle<cr>", desc = "Show problems" },
      { "<leader>vv", "<cmd>WhichKey '' v<cr>", desc = "Show visual maps" },
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto definition" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Show implementations" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Show references" },
      { "{", "{", desc = "Previous symbol" },
      { "}", "}", desc = "Next symbol" },
    }, {
      prefix = "",
    })
  end,
}
