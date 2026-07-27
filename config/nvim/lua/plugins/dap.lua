-- Debug Adapter Protocol: nvim-dap with the UI and language integrations.
-- nvim-dap is also what garmin-monkeyc's `:MonkeyC debug` drives.
return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("dap-go").setup()

      -- Open and close the UI automatically with the debug session.
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
