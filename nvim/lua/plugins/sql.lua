return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      opts.formatters_by_ft.sql = { "pg_format" }
      opts.formatters_by_ft.plsql = { "pg_format" }
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      opts.linters_by_ft.sql = {}
      opts.linters_by_ft.plsql = {}
    end,
  },
}
