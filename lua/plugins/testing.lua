return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python",
          require "neotest-go",
          require("neotest-jest") { jestCommand = "npm test --" },
          require "neotest-rust",
        },
      }
    end,
    keys = {
      -- <leader>tt is the terminal-toggle prefix (see mappings.lua); use
      -- <leader>tn here to avoid the two silently colliding.
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>td", function() require("neotest").run.run { strategy = "dap" } end, desc = "Debug nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Run file tests" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run all tests" },
      { "<leader>to", function() require("neotest").output.open { enter = true } end, desc = "Test output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "[T", function() require("neotest").jump.prev { status = "failed" } end, desc = "Previous failed test" },
      { "]T", function() require("neotest").jump.next { status = "failed" } end, desc = "Next failed test" },
    },
  },
}
