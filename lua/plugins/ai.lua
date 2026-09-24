return {
  -- ============================================================================
  -- Claude Code IDE integration: runs a WebSocket/MCP server that the `claude`
  -- CLI auto-discovers, so a `claude` session (in its own terminal split here)
  -- can see open buffers/selections/diagnostics and apply diffs into them.
  -- Requires the `claude` CLI on PATH (see :CheckDeps).
  --
  -- Default upstream keys all live under <leader>a, which collides with
  -- Harpoon's <leader>a ("add file") in this config — that clash would force
  -- a timeoutlen wait on every Harpoon-add press, so everything below is
  -- remapped onto the free <leader>l ("LLM") prefix instead.
  -- ============================================================================
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    opts = {
      terminal = {
        provider = "snacks",
        split_side = "right",
      },
      diff_opts = {
        layout = "vertical",
      },
      focus_after_send = true,
    },
    keys = {
      { "<leader>lc", "<cmd>ClaudeCode<cr>", desc = "Claude: Toggle terminal" },
      { "<leader>lf", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude: Focus" },
      { "<leader>lr", "<cmd>ClaudeCode --resume<cr>", desc = "Claude: Resume session" },
      { "<leader>lC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude: Continue session" },
      { "<leader>lm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude: Select model" },
      { "<leader>lb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: Add buffer as context" },
      { "<leader>ls", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: Send selection" },
      { "<leader>la", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: Accept diff" },
      { "<leader>ln", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude: Deny diff" },
      { "<leader>lX", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Claude: Close all diffs" },
    },
  },

  -- ============================================================================
  -- Antigravity CLI (`agy`) IDE integration:
  -- Runs a dedicated, persistent session with Google Antigravity (`agy`),
  -- providing interactive chat, session continuation, prompt dialogs, model
  -- selection, reasoning effort selection, and buffer/selection context injection.
  -- Requires the `agy` CLI on PATH (see :CheckDeps).
  --
  -- Keys live under <leader>y ("antigravity / agy"), with fast toggle aliases
  -- under <leader>l ("claude / llm").
  -- ============================================================================
  {
    "NakLast/antigravity-cli.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "Agy",
      "AgyToggle",
      "AgyFocus",
      "AgyContinue",
      "AgyPrompt",
      "AgyAdd",
      "AgySend",
      "AgySelectModel",
      "AgyEffort",
      "AgyMode",
      "Antigravity",
    },
    opts = {
      cmd = "agy",
      position = "right",
      width = 0.42,
      height = 0.85,
      border = "rounded",
    },
    config = function(_, opts)
      require("utils.agy").setup(opts)
    end,
    keys = {
      {
        "<leader>ya",
        function()
          require("utils.agy").toggle()
        end,
        desc = "AGY: Toggle terminal",
      },
      {
        "<leader>yc",
        function()
          require("utils.agy").toggle()
        end,
        desc = "AGY: Toggle terminal",
      },
      {
        "<leader>yf",
        function()
          require("utils.agy").focus()
        end,
        desc = "AGY: Focus terminal",
      },
      {
        "<leader>yC",
        function()
          require("utils.agy").continue_session()
        end,
        desc = "AGY: Continue session",
      },
      {
        "<leader>yr",
        function()
          require("utils.agy").continue_session()
        end,
        desc = "AGY: Resume session",
      },
      {
        "<leader>yp",
        function()
          require("utils.agy").prompt()
        end,
        desc = "AGY: Interactive prompt",
      },
      {
        "<leader>ym",
        function()
          require("utils.agy").select_model()
        end,
        desc = "AGY: Select model",
      },
      {
        "<leader>yb",
        function()
          require("utils.agy").add_buffer(0)
        end,
        desc = "AGY: Add buffer as context",
      },
      {
        "<leader>ys",
        function()
          require("utils.agy").send_selection()
        end,
        mode = "v",
        desc = "AGY: Send selection",
      },
      {
        "<leader>ye",
        function()
          require("utils.agy").select_effort()
        end,
        desc = "AGY: Select effort",
      },
      {
        "<leader>yM",
        function()
          require("utils.agy").toggle_mode()
        end,
        desc = "AGY: Toggle mode (plan/edits)",
      },
      -- Aliases under <leader>l for unified LLM access
      {
        "<leader>ly",
        function()
          require("utils.agy").toggle()
        end,
        desc = "AGY: Toggle terminal",
      },
      {
        "<leader>lY",
        function()
          require("utils.agy").continue_session()
        end,
        desc = "AGY: Continue session",
      },
    },
  },

  -- ============================================================================
  -- GitHub Copilot Chat: interactive chat, code analysis, tests, reviews,
  -- and model selection integrated alongside Claude Code and Antigravity.
  -- Uses `copilot.lua` for authentication (:Copilot auth).
  --
  -- Keys live under <leader>k ("copilot / chat"), with fast toggle alias
  -- under <leader>l ("claude / llm").
  -- ============================================================================
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatDebugInfo",
      "CopilotChatModels",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
    },
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      separator = "───",
      show_help = true,
      auto_follow_cursor = false,
      auto_insert_mode = true,
      window = {
        layout = "vertical",
        width = 0.42,
        border = "rounded",
        title = " Copilot Chat ",
      },
      mappings = {
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
        },
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        accept_diff = {
          normal = "<leader>ka",
          insert = "<C-y>",
        },
        yank_diff = {
          normal = "gy",
        },
        show_diff = {
          normal = "gd",
        },
        show_info = {
          normal = "gi",
        },
        show_context = {
          normal = "gc",
        },
      },
    },
    keys = {
      {
        "<leader>kc",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "Copilot: Toggle chat",
      },
      {
        "<leader>ka",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "Copilot: Toggle chat",
      },
      {
        "<leader>kf",
        function()
          require("CopilotChat").open()
        end,
        desc = "Copilot: Focus chat",
      },
      {
        "<leader>kr",
        function()
          require("CopilotChat").reset()
        end,
        desc = "Copilot: Reset chat session",
      },
      {
        "<leader>kp",
        function()
          local input = vim.fn.input "Copilot prompt: "
          if input and vim.trim(input) ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Copilot: Interactive prompt dialog",
      },
      {
        "<leader>kP",
        function()
          require("CopilotChat").select_prompt()
        end,
        mode = { "n", "x" },
        desc = "Copilot: Select prompt action",
      },
      {
        "<leader>km",
        function()
          require("CopilotChat").select_model()
        end,
        desc = "Copilot: Select model",
      },
      {
        "<leader>kb",
        function()
          local input = vim.fn.input "Ask Copilot about current buffer: "
          if input and vim.trim(input) ~= "" then
            require("CopilotChat").ask(input, {
              selection = require("CopilotChat.select").buffer,
            })
          end
        end,
        desc = "Copilot: Ask with buffer context",
      },
      {
        "<leader>ks",
        function()
          local input = vim.fn.input "Ask Copilot about selection: "
          if input and vim.trim(input) ~= "" then
            require("CopilotChat").ask(input, {
              selection = require("CopilotChat.select").visual,
            })
          end
        end,
        mode = "v",
        desc = "Copilot: Ask with visual selection",
      },
      {
        "<leader>ke",
        "<cmd>CopilotChatExplain<cr>",
        mode = { "n", "v" },
        desc = "Copilot: Explain code",
      },
      {
        "<leader>kR",
        "<cmd>CopilotChatReview<cr>",
        mode = { "n", "v" },
        desc = "Copilot: Review code",
      },
      {
        "<leader>kF",
        "<cmd>CopilotChatFix<cr>",
        mode = { "n", "v" },
        desc = "Copilot: Fix code / diagnostics",
      },
      {
        "<leader>kt",
        "<cmd>CopilotChatTests<cr>",
        mode = { "n", "v" },
        desc = "Copilot: Generate tests",
      },
      {
        "<leader>kd",
        "<cmd>CopilotChatFixDiagnostic<cr>",
        mode = { "n", "v" },
        desc = "Copilot: Fix diagnostic under cursor",
      },
      {
        "<leader>kg",
        "<cmd>CopilotChatCommit<cr>",
        desc = "Copilot: Generate commit message",
      },
      -- Alias under <leader>l for unified LLM access alongside Claude (<leader>lc) and AGY (<leader>ly)
      {
        "<leader>lk",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "Copilot: Toggle chat",
      },
    },
  },

  -- ============================================================================
  -- OpenAI Codex CLI (`codex`) IDE integration:
  -- Runs a dedicated, persistent session with OpenAI Codex CLI, providing
  -- interactive chat, session continuation, prompt dialogs, model selection
  -- (o3, o3-mini, o1, gpt-4o), sandbox policy controls, automated git reviews,
  -- diff application, and buffer/selection context injection.
  -- Requires the `codex` CLI on PATH (see :CheckDeps).
  --
  -- Keys live under <leader>x ("codex / trouble"), with fast toggle aliases
  -- under <leader>l ("claude / llm").
  -- ============================================================================
  {
    name = "codex.nvim",
    dir = vim.fn.stdpath "config",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "Codex",
      "CodexToggle",
      "CodexFocus",
      "CodexResume",
      "CodexResumePicker",
      "CodexPrompt",
      "CodexAdd",
      "CodexSend",
      "CodexSelectModel",
      "CodexSandbox",
      "CodexApproval",
      "CodexSearchToggle",
      "CodexReview",
      "CodexReviewPrompt",
      "CodexApply",
    },
    opts = {
      cmd = "codex",
      position = "right",
      width = 0.42,
      height = 0.85,
      border = "rounded",
    },
    config = function(_, opts)
      require("utils.codex").setup(opts)
    end,
    keys = {
      {
        "<leader>xc",
        function()
          require("utils.codex").toggle()
        end,
        desc = "Codex: Toggle terminal",
      },
      {
        "<leader>xa",
        function()
          require("utils.codex").toggle()
        end,
        desc = "Codex: Toggle terminal",
      },
      {
        "<leader>xf",
        function()
          require("utils.codex").focus()
        end,
        desc = "Codex: Focus terminal",
      },
      {
        "<leader>xr",
        function()
          require("utils.codex").resume_last()
        end,
        desc = "Codex: Resume session",
      },
      {
        "<leader>xR",
        function()
          require("utils.codex").resume_picker()
        end,
        desc = "Codex: Resume session picker",
      },
      {
        "<leader>xp",
        function()
          require("utils.codex").prompt()
        end,
        desc = "Codex: Interactive prompt",
      },
      {
        "<leader>xm",
        function()
          require("utils.codex").select_model()
        end,
        desc = "Codex: Select model",
      },
      {
        "<leader>xb",
        function()
          require("utils.codex").add_buffer(0)
        end,
        desc = "Codex: Add buffer as context",
      },
      {
        "<leader>xs",
        function()
          require("utils.codex").send_selection()
        end,
        mode = "v",
        desc = "Codex: Send selection",
      },
      {
        "<leader>xw",
        function()
          require("utils.codex").select_sandbox()
        end,
        desc = "Codex: Select sandbox mode",
      },
      {
        "<leader>xA",
        function()
          require("utils.codex").select_approval()
        end,
        desc = "Codex: Select approval policy",
      },
      {
        "<leader>xS",
        function()
          require("utils.codex").toggle_search()
        end,
        desc = "Codex: Toggle live web search",
      },
      {
        "<leader>xv",
        function()
          require("utils.codex").review_uncommitted()
        end,
        desc = "Codex: Review uncommitted changes",
      },
      {
        "<leader>xd",
        function()
          require("utils.codex").apply_diff()
        end,
        desc = "Codex: Apply task diff",
      },
      -- Aliases under <leader>l for unified LLM access alongside Claude (<leader>lc), AGY (<leader>ly), Copilot (<leader>lk)
      {
        "<leader>lx",
        function()
          require("utils.codex").toggle()
        end,
        desc = "Codex: Toggle terminal",
      },
      {
        "<leader>lo",
        function()
          require("utils.codex").toggle()
        end,
        desc = "Codex: Toggle terminal (alias)",
      },
      {
        "<leader>lO",
        function()
          require("utils.codex").resume_last()
        end,
        desc = "Codex: Resume session",
      },
    },
  },
}
