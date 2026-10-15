return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
  },
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_save_on_switch = 2
    vim.g.tmux_navigator_disable_when_zoomed = 1

    -- Força o keymap na neotree também
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      callback = function()
        vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { buffer = true })
        vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { buffer = true })
        vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { buffer = true })
        vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { buffer = true })
      end,
    })
  end,
}
