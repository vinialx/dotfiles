local executable = require("util.executable")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          mason = false,
          enabled = executable.has("lua-language-server"),
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        stylua = {
          condition = function()
            return executable.has("stylua")
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },

      linters = {
        selene = {
          condition = function()
            return executable.has("selene")
          end,
        },
      },
    },
  },
}
