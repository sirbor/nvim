return {
  -- Harpoon v2
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
    keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>he",
        function()
          local harpoon = require "harpoon"
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<leader>hn",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon next",
      },
      {
        "<leader>hN",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon prev",
      },
    },
  },

  -- FzfLua is the primary picker; its keymaps live in mappings.lua.
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        "default-title",
        fzf_colors = true,
        winopts = {
          height = 0.85,
          width = 0.85,
          preview = {
            default = "builtin",
            border = "rounded",
            layout = "horizontal",
            horizontal = "right:50%",
            hidden = "nohidden",
          },
        },
        keymap = {
          builtin = {
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<M-p>"] = "toggle-preview",
            ["<C-p>"] = "toggle-preview",
          },
          fzf = {
            ["alt-p"] = "toggle-preview",
            ["ctrl-p"] = "toggle-preview",
          },
        },
        files = {
          cwd_prompt = false,
          git_icons = true,
          previewer = "builtin",
        },
        buffers = {
          previewer = "builtin",
        },
        oldfiles = {
          include_current_session = true,
          previewer = "builtin",
        },
        grep = {
          rg_glob = true,
          previewer = "builtin",
        },
        defaults = {
          git_icons = true,
          file_icons = true,
        },
      }
    end,
    config = function(_, opts)
      local fzf = require "fzf-lua"
      fzf.setup(opts)
      fzf.register_ui_select()
    end,
  },

  -- Oil: edit the filesystem like a buffer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      default_file_explorer = false,
      columns = { "icon" },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".." or name == ".git"
        end,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-p>"] = "actions.preview",
        ["K"] = "actions.preview",
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
      float = {
        padding = 2,
        max_width = 100,
        max_height = 40,
        border = "rounded",
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>o", "<cmd>Oil<cr>", desc = "Oil file manager" },
      {
        "<leader>oF",
        function()
          require("oil").toggle_float()
        end,
        desc = "Oil (float)",
      },
    },
  },

  -- Display and interact with Vim marks in the sign column
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = true,
      signs = true,
      mappings = {
        set_next = "m,",
        next = "m]",
        prev = "m[",
        preview = "m:",
      },
    },
  },
}
