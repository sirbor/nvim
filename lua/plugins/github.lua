return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "ibhagwan/fzf-lua",
    },
    opts = {
      enable_builtin = true,
      picker = "fzf-lua",
      default_to_projects_v2 = true,
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "GitHub issues" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "GitHub pull requests" },
      { "<leader>gr", "<cmd>Octo review<cr>", desc = "Review pull request" },
    },
  },
}
