return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = { auto_open = { enabled = false } },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d+ more lines" },
              { find = "%d+ fewer lines" },
              { find = "%d+ lines yanked" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    keys = {
      {
        "<leader>uN",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>sn",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice history",
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 2500,
      render = "compact",
      stages = "fade",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        width = 100,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          foldcolumn = "0",
        },
      },
      plugins = {
        options = { enabled = true, ruler = false, showcmd = false, laststatus = 0 },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
    },
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
  },

  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {
      dimming = { alpha = 0.35 },
      context = 12,
    },
    keys = {
      { "<leader>tw", "<cmd>Twilight<cr>", desc = "Twilight" },
    },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
    end,
    keys = {
      { "<leader>ud", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = function()
        pcall(vim.cmd, "NvimTreeClose")
        pcall(function()
          local ok, dapui = pcall(require, "dapui")
          if ok then
            dapui.close()
          end
        end)
      end,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't save session",
      },
    },
  },

  -- Lightweight, beautiful one-line inline diagnostic messages
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    opts = {
      preset = "modern",
      hi = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
      },
      options = {
        show_source = true,
        use_icons_from_diagnostic = true,
        add_messages = true,
        multilines = false,
      },
    },
    keys = {
      {
        "<leader>ui",
        function()
          require("tiny-inline-diagnostic").toggle()
        end,
        desc = "Toggle inline diagnostics",
      },
    },
  },

  -- Dynamic colorcolumn that hides when lines are within limits
  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      colorcolumn = "100",
      disabled_filetypes = { "help", "text", "markdown", "nvdash", "NvimTree", "lazy", "mason", "oil" },
      scope = "window",
    },
  },
}
