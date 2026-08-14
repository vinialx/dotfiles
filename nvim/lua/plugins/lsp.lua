return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--query-driver=/etc/profiles/**,/nix/store/**",
          },
        },
      },
    },
  },
}
