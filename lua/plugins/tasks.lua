return {
  -- ============================================================================
  -- Overseer: Asynchronous Task Runner & Build Manager
  -- ============================================================================
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerToggle",
      "OverseerRun",
      "OverseerBuild",
      "OverseerClose",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    opts = {
      strategy = "terminal",
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 8,
        max_height = 20,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["q"] = "Close",
        },
      },
    },
    keys = {
      { "<leader>Oo", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle task list" },
      { "<leader>Or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run task" },
      { "<leader>Ob", "<cmd>OverseerBuild<cr>", desc = "Overseer: Build task" },
      { "<leader>Oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer: Quick action" },
      { "<leader>Oi", "<cmd>OverseerInfo<cr>", desc = "Overseer: Task runner info" },
    },
  },

  -- ============================================================================
  -- TreeSJ: Structural Split / Join for Arrays, Objects, Arguments
  -- ============================================================================
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
    keys = {
      {
        "<leader>cj",
        function()
          require("treesj").toggle()
        end,
        desc = "Toggle split / join code block",
      },
      {
        "<leader>cS",
        function()
          require("treesj").split()
        end,
        desc = "Split code block",
      },
      {
        "<leader>cJ",
        function()
          require("treesj").join()
        end,
        desc = "Join code block",
      },
    },
  },

  -- ============================================================================
  -- Dropbar: Interactive IDE Breadcrumbs (File -> Class -> Function)
  -- ============================================================================
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      bar = {
        enable = function(buf, win)
          return vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_win_is_valid(win)
            and vim.wo[win].winbar == ""
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains({ "nvdash", "terminal", "prompt" }, vim.bo[buf].filetype)
        end,
      },
    },
  },

  -- ============================================================================
  -- Render Markdown: In-Editor Rich Markdown Rendering for RFCs & Docs
  -- ============================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = true,
        width = "block",
        right_pad = 2,
      },
      checkbox = {
        enabled = true,
      },
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle rendered markdown" },
    },
  },

  -- ============================================================================
  -- Git Worktree: Frictionless Parallel Branch Workspaces
  -- ============================================================================
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>gw",
        function()
          local ok, fzf = pcall(require, "fzf-lua")
          if ok then
            -- Use FzfLua or standard picker if available
            require("git-worktree").create_git_worktree()
          end
        end,
        desc = "Git Worktree: Create worktree",
      },
      {
        "<leader>gW",
        function()
          require("git-worktree").switch_worktree()
        end,
        desc = "Git Worktree: Switch worktree",
      },
    },
    config = function()
      require("git-worktree").setup()
    end,
  },

  -- ============================================================================
  -- Code Coverage Display (LCOV, Cobertura, pytest-cov, go test cover)
  -- ============================================================================
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "Coverage",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
      "CoverageLoad",
    },
    opts = {
      auto_reload = true,
    },
    keys = {
      { "<leader>Ct", "<cmd>CoverageToggle<cr>", desc = "Coverage: Toggle signs" },
      { "<leader>Cs", "<cmd>CoverageSummary<cr>", desc = "Coverage: Summary report" },
      { "<leader>Cl", "<cmd>CoverageLoad<cr>", desc = "Coverage: Load coverage data" },
      { "<leader>Cc", "<cmd>CoverageClear<cr>", desc = "Coverage: Clear highlights" },
    },
  },
}
