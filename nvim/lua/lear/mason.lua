return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = false,
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = false,
  },
}
