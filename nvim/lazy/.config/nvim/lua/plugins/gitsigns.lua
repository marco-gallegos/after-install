return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local gitsigns = require "gitsigns"
    gitsigns.setup {
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
        interval = 1000,
            follow_files = true
        },
        trouble = false,
        on_attach = function(bufnr)
        --vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr })
        --vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { buffer = bufnr })
        --vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr })
        --vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr })
        --vim.keymap.set("n", "<leader>hj", gitsigns.next_hunk, { buffer = bufnr })
        --vim.keymap.set("n", "<leader>hk", gitsigns.prev_hunk, { buffer = bufnr })
        end,
        max_file_length = 10000,
    }
  end,
}
