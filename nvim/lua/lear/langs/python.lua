local executable = require("util.executable")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          mason = false,
          enabled = executable.has("basedpyright-langserver"),

          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },

      formatters = {
        ruff_format = {
          condition = function()
            return executable.has("ruff")
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },

      linters = {
        ruff = {
          condition = function()
            return executable.has("ruff")
          end,
        },
      },
    },
  },
}
