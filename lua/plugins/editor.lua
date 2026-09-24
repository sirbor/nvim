return {
  -- Better Lua development for Neovim config/plugin files
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      user_default_options = {
        names = false,
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        css = true,
        css_fn = true,
        tailwind = true,
        mode = "background",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(nil, opts)
    end,
    keys = {
      {
        "<leader>uC",
        "<cmd>ColorizerToggle<cr>",
        desc = "Toggle colorizer",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev todo",
      },
      { "<leader>ft", "<cmd>Trouble todo toggle<cr>", desc = "Todos" },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      focus = true,
      modes = {
        symbols = { win = { position = "right", size = 0.3 } },
        lsp = { win = { position = "right", size = 0.3 } },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP refs" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = true },
        char = { jump_labels = true },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle flash search" },
    },
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "NvimTree", "oil", "Trouble", "notify" },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- Avoid <C-n> clash with NvimTreeToggle
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<M-n>",
        ["Find Subword Under"] = "<M-n>",
      }
      vim.g.VM_theme = "iceblue"
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },

  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "gs", function() require("substitute").operator() end, desc = "Substitute" },
      { "gss", function() require("substitute").line() end, desc = "Substitute line" },
      { "gs", function() require("substitute").visual() end, mode = "x", desc = "Substitute" },
    },
  },

  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { snippet_engine = "luasnip" },
    keys = {
      { "<leader>cg", function() require("neogen").generate() end, desc = "Generate docs" },
      { "<leader>cF", function() require("neogen").generate { type = "func" } end, desc = "Function docs" },
      { "<leader>cc", function() require("neogen").generate { type = "class" } end, desc = "Class docs" },
      { "<leader>ct", function() require("neogen").generate { type = "type" } end, desc = "Type docs" },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search & replace" },
      { "<leader>sw", function() require("spectre").open_visual { select_word = true } end, desc = "Replace word" },
      { "<leader>sp", function() require("spectre").open_file_search { select_word = true } end, desc = "Replace in file" },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      open_fold_hl_timeout = 150,
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds" },
      {
        "zp",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Peek fold",
      },
    },
  },

  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      { "g<C-a>", function() return require("dial.map").inc_gnormal() end, expr = true, desc = "Increment gn" },
      { "g<C-x>", function() return require("dial.map").dec_gnormal() end, expr = true, desc = "Decrement gn" },
      { "<C-a>", function() return require("dial.map").inc_visual() end, mode = "v", expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_visual() end, mode = "v", expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.constant.new { elements = { "true", "false" }, word = true, cyclic = true },
          augend.constant.new { elements = { "True", "False" }, word = true, cyclic = true },
          augend.constant.new { elements = { "let", "const" }, word = true, cyclic = true },
          augend.constant.new { elements = { "&&", "||" }, word = false, cyclic = true },
          augend.constant.new { elements = { "and", "or" }, word = true, cyclic = true },
        },
      }
    end,
  },

  -- High-performance buffer-based live search and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sg",
        function()
          require("grug-far").open()
        end,
        desc = "Grug-far: Search & replace workspace",
      },
      {
        "<leader>sR",
        function()
          require("grug-far").open()
        end,
        desc = "Grug-far: Search & replace workspace",
      },
      {
        "<leader>sW",
        function()
          require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } }
        end,
        desc = "Grug-far: Search current word",
      },
      {
        "<leader>sF",
        function()
          require("grug-far").open { prefills = { paths = vim.fn.expand "%" } }
        end,
        desc = "Grug-far: Search current file",
      },
    },
  },

  -- CamelCase and snake_case aware subword motions
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider-w" },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider-e" },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider-b" },
      { "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" }, desc = "Spider-ge" },
    },
  },

  -- Advanced yank ring, paste cycling, and clipboard history
  {
    "gbprod/yanky.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ring = { history_length = 100 },
      highlight = { timer = 150 },
    },
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle yank backward" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle yank forward" },
      { "<C-p>", "<Plug>(YankyCycleForward)", desc = "Cycle yank backward" },
      { "<C-n>", "<Plug>(YankyCycleBackward)", desc = "Cycle yank forward" },
      {
        "<leader>fy",
        function()
          local ok, fzf = pcall(require, "fzf-lua")
          if ok then
            fzf.registers()
          else
            require("telescope").extensions.yank_history.yank_history()
          end
        end,
        desc = "Yank history",
      },
    },
  },

  -- Enhanced quickfix window with floating preview and fzf filtering
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        winblend = 12,
        border = "rounded",
      },
    },
  },

  -- Interactive search count and position lens
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    opts = {},
    keys = {
      {
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Next search match with hlslens",
      },
      {
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Prev search match with hlslens",
      },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word forward with hlslens" },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word backward with hlslens" },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word forward (partial) with hlslens" },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word backward (partial) with hlslens" },
    },
  },

  -- Tree-sitter powered rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Automatic tab/space and indentation width detection
  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- Prevent nested Neovim instances in terminal buffers
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      window = { open = "alternate" },
      hooks = {
        pipe_path = function()
          if vim.env.NVIM then
            local ok, sock = pcall(vim.fn.sockconnect, "pipe", vim.env.NVIM, { rpc = true })
            if ok and sock > 0 then
              local ok_rpc, has_flatten = pcall(vim.rpcrequest, sock, "nvim_exec_lua", "return pcall(require, 'flatten')", {})
              pcall(vim.fn.chanclose, sock)
              if ok_rpc and has_flatten then
                return vim.env.NVIM
              end
            end
          end
          return nil
        end,
      },
    },
  },
}
