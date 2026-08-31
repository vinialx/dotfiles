local executable = require("util.executable")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
          enabled = executable.has("clangd"),

          cmd = {
            "clangd",
            "--query-driver=/etc/profiles/**,/nix/store/**",
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },

      formatters = {
        clang_format = {
          condition = function()
            return executable.has("clang-format")
          end,
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        c = { "clangtidy" },
        cpp = { "clangtidy" },
      },

      linters = {
        clangtidy = {
          condition = function()
            return executable.has("clang-tidy")
          end,
        },
      },
    },
  },
}
