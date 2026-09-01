local executable = require("util.executable")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = {
          mason = false,
          enabled = executable.has("nil"),
        },
      },
    },
  },
}
