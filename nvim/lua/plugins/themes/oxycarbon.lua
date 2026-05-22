return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    -- Set the theme as the default for LazyVim
    config = function()
      vim.opt.background = "dark" -- or "light" if you prefer
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}
