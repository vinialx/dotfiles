return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
      vim.cmd("colorscheme oxocarbon")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}
