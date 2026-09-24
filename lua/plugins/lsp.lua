return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- Install on startup so LSP binaries exist before FilePost
    event = "VimEnter",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSPs
        "lua-language-server",
        "basedpyright",
        "pyright",
        "ruff",
        "clangd",
        "jdtls",
        "kotlin-language-server",
        "typescript-language-server",
        "tailwindcss-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "bash-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "terraform-ls",
        "helm-ls",
        "tflint",
        "gopls",
        "rust-analyzer",
        "lemminx",
        -- Formatters
        "stylua",
        "google-java-format",
        "ktlint",
        "clang-format",
        "prettierd",
        "prettier",
        "shfmt",
        "gofumpt",
        "goimports",
        "xmlformatter",
        -- Linters
        "eslint_d",
        "shellcheck",
        "yamllint",
        "hadolint",
        "sqlfluff",
        "golangci-lint",
        -- Debuggers (DAP)
        "debugpy",
        "codelldb",
        "js-debug-adapter",
        "delve",
        "java-debug-adapter",
        "java-test",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 1000,
    },
  },

  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      backend = { "nui" },
    },
    keys = {
      {
        "<leader>ca",
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "n", "v" },
        desc = "Code actions",
      },
    },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
    keys = {
      {
        -- Avoid NvChad <leader>rn (relative number toggle)
        "<leader>cr",
        function()
          return ":IncRename " .. vim.fn.expand "<cword>"
        end,
        expr = true,
        desc = "Rename symbol",
      },
    },
  },

  {
    "antosha417/nvim-lsp-file-operations",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    opts = {},
  },

  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        max_width = { 40, 0.25 },
        min_width = 25,
        win_opts = { winblend = 10 },
      },
      show_guides = true,
      filter_kind = false,
      keymaps = {
        ["{"] = false,
        ["}"] = false,
        ["[["] = false,
        ["]]"] = false,
      },
    },
    keys = {
      { "<leader>co", "<cmd>AerialToggle!<CR>", desc = "Symbol outline" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "python",
        "java",
        "kotlin",
        "rust",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "c",
        "cpp",
        "bash",
        "dockerfile",
        "terraform",
        "hcl",
        "helm",
        "jsonc",
        "luadoc",
        "sql",
        "regex",
        "http",
        "swift",
        "objc",
        "dart",
        "xml",
        -- dbt macros/templates and standalone .jinja files (tree-sitter-sql has
        -- no jinja-injection query, so this only lights up *.jinja/htmldjango
        -- buffers directly, not the jinja tags inside .sql models — see README §4)
        "jinja",
        "jinja_inline",
        -- pipeline/data files: csv/tsv alongside the json/yaml/toml already above
        "csv",
        "tsv",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>cn"] = "@parameter.inner" },
          swap_previous = { ["<leader>cp"] = "@parameter.inner" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      mode = "cursor",
      max_lines = 3,
      multiline_threshold = 1,
    },
    keys = {
      {
        "<leader>uc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle treesitter context",
      },
    },
  },

  -- Catalog of JSON and YAML schemas for language servers
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },

  -- Off-spec clangd features (AST, type hierarchy, inlay hints, memory usage)
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    opts = {
      inlay_hints = {
        inline = true,
      },
      ast = {
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
      },
    },
    keys = {
      { "<leader>ch", "<cmd>ClangdTypeHierarchy<cr>", desc = "Clangd: Type hierarchy" },
      { "<leader>cM", "<cmd>ClangdMemoryUsage<cr>", desc = "Clangd: Memory usage" },
      { "<leader>cT", "<cmd>ClangdAST<cr>", desc = "Clangd: AST view" },
      { "<leader>cS", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Clangd: Switch source / header" },
    },
  },

  -- Sort Python dunder methods to the bottom in completion lists
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "lukas-reineke/cmp-under-comparator",
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.sorting = opts.sorting or {}
      opts.sorting.comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      }
    end,
  },
}
