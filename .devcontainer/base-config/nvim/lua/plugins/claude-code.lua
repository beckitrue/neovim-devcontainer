-- claude-code.nvim plugin configuration
return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claude-code").setup({
      -- Window configuration
      window = {
        type = "split",  -- "split" or "float"
        position = "right",  -- "left", "right", "top", "bottom" (for split)
        width = 80,  -- Width for vertical split or float
        height = 20,  -- Height for horizontal split or float
      },

      -- Keymaps
      keymaps = {
        toggle = {
          normal = "<C-,>",  -- Toggle Claude Code terminal in normal mode
        },
        continue = {
          normal = "<leader>cC",  -- Continue conversation in normal mode
        },
        verbose = {
          normal = "<leader>cV",  -- Verbose mode in normal mode
        },
      },

      -- Shell configuration
      shell = {
        cmd = vim.o.shell,
        args = { "-c" },
        separator = ";",
      },

      -- Command configuration
      command = "claude-code",

      -- Auto-refresh files when changes detected
      auto_refresh = true,

      -- Log level (debug, info, warn, error)
      log_level = "info",
    })

    -- Additional keymaps for convenience
    vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Open Claude Code" })
    vim.keymap.set("n", "<leader>ct", "<cmd>ClaudeCodeToggle<cr>", { desc = "Toggle Claude Code" })
    vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude Code" })
  end,
}