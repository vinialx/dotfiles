return {
  {
    "uga-rosa/ccc.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    keys = {
      { "<leader>cp", "<cmd>CccPick<cr>", desc = "Color Pick" },
      { "<leader>cc", "<cmd>CccConvert<cr>", desc = "Color Convert" },
      { "<leader>ch", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Color Highlighter" },
    },
    opts = {
      -- Your options go here
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
    config = function(_, opts)
      local ccc = require("ccc")
      ccc.setup(opts)
    end,
  },
}
