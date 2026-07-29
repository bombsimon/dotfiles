return {
  {
    "github/copilot.vim",
    config = function()
      -- Disable default Tab mapping to avoid conflict with nvim-cmp
      vim.g.copilot_no_tab_map = true

      -- Custom keybindings for Copilot
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)")
      vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)")

      -- disable copilot by default
      vim.g.copilot_enabled = false
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      display = {
        action_palette = {
          provider = "default",
        },
      },
      adapters = {
        acp = {
          -- https://code.claude.com/docs/en/quickstart#step-1-install-claude-code
          -- npm i -g @agentclientprotocol/claude-agent-acp
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              formatted_name = "Claude Code (personal)",
              env = {
                -- CLAUDE_CONFIG_DIR = "~/.claude-personal"
                CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read 'op://Personal/Claude Code oAuth token/credential'",
              },
            })
          end,
          claude_code_work = function()
            return require("codecompanion.adapters").extend("claude_code", {
              name = "claude_code_work",
              formatted_name = "Claude Code (work)",
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = ("cmd:op read 'op://%s/Claude Code oAuth token/credential'"):format(
                  vim.env.WORK_VAULT
                ),
              },
            })
          end,

          -- https://github.com/openai/codex#quickstart
          -- npm i -g @agentclientprotocol/codex-acp
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chat-gpt", -- "api-key"|"chat-gpt"
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "claude_code",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
      },
      opts = {
        log_level = "INFO",
      },
    },
  },
}
