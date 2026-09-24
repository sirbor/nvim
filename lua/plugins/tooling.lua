return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
    },
  },
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    dependencies = { "tpope/vim-dadbod" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle database UI" },
      { "<leader>Db", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
      { "<leader>Dr", "<cmd>DB<cr>", mode = { "n", "v" }, desc = "Execute SQL query" },
      { "<leader>Dt", "<cmd>DBUIFindBuffer<cr>", desc = "Find table in DB" },
      { "<leader>Ds", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      "tpope/vim-dadbod",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("cmp").setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "percent",
      output_extension = "auto",
      force_ft = "python",
    },
  },

  -- ============================================================================
  -- Molten: real Jupyter-kernel-backed cell execution with rich output
  -- (dataframes, plots, images) rendered inline. Requires a Python env with
  -- `pynvim` and `jupyter_client` installed (`:CheckDeps` reports on these) —
  -- without them the plugin loads but `:MoltenInit` will fail. This is heavier
  -- than the plain `<leader>j*` IPython-REPL flow in mappings.lua (which needs
  -- nothing but `ipython` on PATH); reach for Molten when you actually want
  -- inline output, otherwise the REPL flow is the zero-setup default.
  -- ============================================================================
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = function()
      pcall(vim.cmd, "UpdateRemotePlugins")
    end,
    ft = { "python", "quarto", "markdown" },
    init = function()
      -- No image provider configured: matplotlib/plot output won't render inline
      -- (needs image.nvim + a terminal that supports the Kitty graphics protocol,
      -- not installed here). Text/dataframe/table output works without it.
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>Mi", "<cmd>MoltenInit<cr>", desc = "Molten: Initialize kernel" },
      { "<leader>Me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten: Evaluate operator" },
      { "<leader>Ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten: Evaluate line" },
      { "<leader>Mv", ":<C-u>MoltenEvaluateVisual<cr>gv", mode = "v", desc = "Molten: Evaluate selection" },
      { "<leader>Mc", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten: Re-evaluate cell" },
      { "<leader>Mo", "<cmd>MoltenShowOutput<cr>", desc = "Molten: Show output" },
      { "<leader>Mh", "<cmd>MoltenHideOutput<cr>", desc = "Molten: Hide output" },
      { "<leader>Md", "<cmd>MoltenDelete<cr>", desc = "Molten: Delete cell" },
      { "<leader>Mx", "<cmd>MoltenInterrupt<cr>", desc = "Molten: Interrupt kernel" },
      { "<leader>Mr", "<cmd>MoltenRestart!<cr>", desc = "Molten: Restart kernel" },
    },
  },

  -- Interactive CSV/TSV table viewer with column alignment and sorting
  {
    "hat0uma/csvview.nvim",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    ft = { "csv", "tsv" },
    opts = {
      parser = { comments = { "#", "//" } },
      view = { display_mode = "border" },
    },
    keys = {
      { "<leader>uv", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV table view" },
    },
  },

  -- Inline graphics protocol renderer (enables Molten plots and markdown diagrams/images)
  {
    "3rd/image.nvim",
    ft = { "markdown", "quarto", "python" },
    opts = {
      backend = "kitty",
      max_width = 100,
      max_height = 16,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- Paste images from clipboard into Markdown, LaTeX, and Typst
  {
    "HakonHarnes/img-clip.nvim",
    cmd = { "PasteImage" },
    ft = { "markdown", "quarto", "tex", "typst" },
    opts = {
      default = {
        dir_path = "assets",
        prompt_for_file_name = false,
        use_absolute_path = false,
      },
    },
    keys = {
      { "<leader>ci", "<cmd>PasteImage<cr>", desc = "Insert image from clipboard" },
    },
  },

  -- Cargo.toml dependency manager and version inspector for Rust
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
    },
    keys = {
      { "<leader>nt", function() require("crates").toggle() end, desc = "Crates: Toggle virtual text" },
      { "<leader>nr", function() require("crates").reload() end, desc = "Crates: Reload" },
      { "<leader>nu", function() require("crates").update_crate() end, desc = "Crates: Update crate" },
      { "<leader>na", function() require("crates").update_all_crates() end, desc = "Crates: Update all crates" },
      { "<leader>nH", function() require("crates").open_homepage() end, desc = "Crates: Open homepage" },
      { "<leader>nD", function() require("crates").open_documentation() end, desc = "Crates: Open documentation" },
    },
  },

  -- package.json dependency manager and version inspector for Node/TS
  {
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    keys = {
      { "<leader>ns", function() require("package-info").show() end, desc = "Package: Show versions" },
      { "<leader>nh", function() require("package-info").hide() end, desc = "Package: Hide versions" },
      { "<leader>nu", function() require("package-info").update() end, desc = "Package: Update dependency" },
      { "<leader>nd", function() require("package-info").delete() end, desc = "Package: Delete dependency" },
      { "<leader>ni", function() require("package-info").install() end, desc = "Package: Install new dependency" },
    },
  },

  -- Synchronized browser preview for Markdown files
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>uM", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown browser preview" },
    },
  },
}
