return {
  -- Conform for formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format {
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          }
        end,
        mode = { "n", "v" },
        desc = "Format file / range (Conform)",
      },
    },
  },

  -- Nvim-lint for asynchronous linting (Python/Rust use LSP: ruff / rust-analyzer)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        go = { "golangcilint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
        terraform = { "tflint" },
        tf = { "tflint" },
        sql = { "sqlfluff" },
        mysql = { "sqlfluff" },
        plsql = { "sqlfluff" },
        swift = { "swiftlint" },
        kotlin = { "ktlint" },
      }

      local function resolve_cmd(name)
        local l = lint.linters[name]
        if type(l) == "table" then
          if type(l.cmd) == "string" then
            return l.cmd
          elseif type(l.cmd) == "function" then
            local ok, res = pcall(l.cmd)
            if ok and type(res) == "string" then
              return res
            end
          end
        elseif type(l) == "function" then
          local ok, res = pcall(l)
          if ok and type(res) == "table" and type(res.cmd) == "string" then
            return res.cmd
          end
        end
        return name
      end

      local function safe_lint()
        local ft = vim.bo.filetype
        local lnames = lint.linters_by_ft[ft] or {}
        local valid = {}
        for _, name in ipairs(lnames) do
          local cmd = resolve_cmd(name)
          if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
            table.insert(valid, name)
          end
        end
        if #valid > 0 then
          pcall(lint.try_lint, valid)
        end
      end

      local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.buftype == "" and vim.bo.modifiable then
            safe_lint()
          end
        end,
      })
    end,
    keys = {
      {
        "<leader>cL",
        function()
          local lint = require "lint"
          local ft = vim.bo.filetype
          local lnames = lint.linters_by_ft[ft] or {}
          local valid = {}
          for _, name in ipairs(lnames) do
            local l = lint.linters[name]
            local cmd = type(l) == "table" and l.cmd or name
            if vim.fn.executable(cmd) == 1 then
              table.insert(valid, name)
            end
          end
          if #valid > 0 then
            lint.try_lint(valid)
          else
            vim.notify("No available linter found for " .. ft, vim.log.levels.INFO)
          end
        end,
        desc = "Trigger linting for current file",
      },
    },
  },
}
