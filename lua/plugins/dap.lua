return {
  -- Debug Adapter Protocol (DAP)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      -- Auto open/close dap-ui when debugging session starts/stops
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint icons
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })

      -- Mason dap setup (sole source of DAP adapter installs)
      require("mason-nvim-dap").setup {
        automatic_installation = true,
        ensure_installed = { "delve", "python", "codelldb", "js", "javadbg", "javatest" },
        handlers = {},
      }
    end,
    keys = {
      { "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Toggle Persistent Breakpoint (DAP)" },
      { "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end, desc = "Conditional Persistent Breakpoint (DAP)" },
      { "<leader>dD", function() require("persistent-breakpoints.api").clear_all_breakpoints() end, desc = "Clear all Breakpoints (DAP)" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue / Start (DAP)" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor (DAP)" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over (DAP)" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over (DAP)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into (DAP)" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out (DAP)" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL (DAP)" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last Debug Session (DAP)" },
      { "<leader>dx", function() require("dap").terminate() require("dapui").close() end, desc = "Terminate (DAP)" },
      { "<leader>dt", function() require("dap").terminate() require("dapui").close() end, desc = "Terminate (DAP)" },
    },
  },

  -- Persistent breakpoints across restarts
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPost",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
  },

  -- Rapid print/log statement insertion and cleanup
  {
    "andrewferrier/debugprint.nvim",
    opts = {
      keymaps = {
        normal = {
          plain_below = "<leader>dp",
          plain_above = "<leader>dP",
          variable_below = "<leader>dv",
          variable_above = "<leader>dV",
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = nil,
          textobj_above = nil,
          toggle_comment_debug_prints = nil,
          delete_debug_prints = "<leader>dK",
        },
        visual = {
          variable_below = "<leader>dv",
          variable_above = "<leader>dV",
        },
      },
      commands = {
        toggle_comment_debug_prints = "ToggleCommentDebugPrints",
        delete_debug_prints = "DeleteDebugPrints",
        reset_debug_prints_counter = "ResetDebugPrintsCounter",
      },
    },
    keys = {
      { "<leader>dp", desc = "Debugprint: plain below" },
      { "<leader>dP", desc = "Debugprint: plain above" },
      { "<leader>dv", desc = "Debugprint: variable below" },
      { "<leader>dV", desc = "Debugprint: variable above" },
      { "<leader>dK", desc = "Debugprint: delete all logs" },
      { "<leader>dv", mode = "x", desc = "Debugprint: variable below" },
      { "<leader>dV", mode = "x", desc = "Debugprint: variable above" },
    },
  },

  -- Python DAP adapter integration
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.filereadable(path) == 0 then
        path = "python3"
      end
      require("dap-python").setup(path)
    end,
    -- <leader>pd (test_method) is bound in mappings.lua, which also loads
    -- after this spec's keys would register — kept there as the single
    -- source of truth so the two don't drift.
    keys = {
      {
        "<leader>pC",
        function()
          require("dap-python").test_class()
        end,
        desc = "Debug Python class (DAP)",
      },
    },
  },

  -- Python Virtual Environment Selector (supports uv, poetry, venv, pyenv, conda)
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    -- <leader>pv is bound in mappings.lua; kept there as the single source
    -- of truth so the two don't drift.
  },
}
