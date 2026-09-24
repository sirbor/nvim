-- NvChad plugin overrides + shared which-key groups
return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug / diagnostics" },
        { "<leader>s", group = "search / split" },
        { "<leader>t", group = "test / terminal" },
        { "<leader>x", group = "codex / trouble" },
        { "<leader>q", group = "session" },
        { "<leader>u", group = "ui" },
        { "<leader>h", group = "harpoon" },
        { "<leader>b", group = "buffers" },
        { "<leader>r", group = "run / project" },
        { "<leader>e", group = "explorer" },
        { "<leader>p", group = "python / venv" },
        { "<leader>j", group = "jupyter / cells" },
        { "<leader>l", group = "claude / llm" },
        { "<leader>y", group = "antigravity / agy" },
        { "<leader>k", group = "copilot / chat" },
        { "<leader>M", group = "molten / kernel" },
        { "<leader>m", group = "maven / gradle / build" },
        { "<leader>R", group = "http (kulala)" },
        { "<leader>D", group = "database" },
        { "<leader>i", group = "ios / xcode" },
        { "<leader>X", group = "xcode / ios" },
        { "<leader>F", group = "flutter / dart" },
        { "<leader>A", group = "android / logcat" },
        { "<leader>O", group = "overseer / tasks" },
        { "<leader>C", group = "coverage" },
        { "<leader>n", group = "packages / dependencies" },
        { "]", group = "next" },
        { "[", group = "prev" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = false,
      current_line_blame_opts = { delay = 400 },
      preview_config = { border = "rounded" },
    },
    keys = {
      {
        "]h",
        function()
          require("gitsigns").nav_hunk "next"
        end,
        desc = "Next hunk",
      },
      {
        "[h",
        function()
          require("gitsigns").nav_hunk "prev"
        end,
        desc = "Prev hunk",
      },
      {
        "<leader>gS",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Stage hunk",
      },
      {
        "<leader>gR",
        function()
          require("gitsigns").reset_hunk()
        end,
        desc = "Reset hunk",
      },
      {
        "<leader>gP",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview hunk",
      },
      {
        "<leader>gb",
        function()
          require("gitsigns").blame_line { full = true }
        end,
        desc = "Blame line",
      },
      {
        "<leader>gB",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle line blame",
      },
    },
  },

  -- Align with NvChad's mason package; keep rounded UI.
  -- Load early so mason/bin is on PATH before language servers start.
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Keep Telescope installed for NvChad internals, but unused as a daily picker
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
      },
    },
  },
}
