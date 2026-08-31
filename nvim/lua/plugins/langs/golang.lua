local executable = require("util.executable")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          mason = false,
          enabled = executable.has("gopls"),

          settings = {
            gopls = {
              gofumpt = true,

              analyses = {
                unusedparams = true,
                unusedwrite = true,
                nilness = true,
                shadow = true,
              },

              staticcheck = true,

              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
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
        go = { "gofumpt" },
      },

      formatters = {
        gofumpt = {
          condition = function()
            return executable.has("gofumpt")
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },

      linters = {
        golangcilint = {
          condition = function()
            return executable.has("golangci-lint")
          end,
        },
      },
    },
  },
}
