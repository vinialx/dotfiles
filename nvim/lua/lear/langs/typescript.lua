local executable = require("util.executable")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          mason = false,
          enabled = executable.has("vtsls"),

          settings = {
            complete_function_calls = true,

            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
            },

            typescript = {
              updateImportsOnFileMove = {
                enabled = "always",
              },

              suggest = {
                completeFunctionCalls = true,
              },

              inlayHints = {
                enumMemberValues = {
                  enabled = true,
                },

                functionLikeReturnTypes = {
                  enabled = true,
                },

                parameterNames = {
                  enabled = "literals",
                },

                parameterTypes = {
                  enabled = true,
                },

                propertyDeclarationTypes = {
                  enabled = true,
                },

                variableTypes = {
                  enabled = false,
                },
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
        javascript = { "prettier" },
        javascriptreact = { "prettier" },

        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        json = { "prettier" },
        jsonc = { "prettier" },
      },

      formatters = {
        prettier = {
          condition = function()
            return executable.has("prettier")
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },

        typescript = { "eslint" },
        typescriptreact = { "eslint" },
      },

      linters = {
        eslint = {
          condition = function()
            return executable.has("eslint")
          end,
        },
      },
    },
  },
}
