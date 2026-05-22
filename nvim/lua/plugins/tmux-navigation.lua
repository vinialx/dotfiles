return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy", -- Esse é o segredo que o post revelou!
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Janela da Esquerda" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Janela de Baixo" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Janela de Cima" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Janela da Direita" },
  },
  config = function()
    -- Desativa os mapeamentos padrões do próprio plugin para não duplicar com os nossos acima
    vim.g.tmux_navigator_no_mappings = 1
  end,
}
