return {
  "aktersnurra/no-clown-fiesta.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("no-clown-fiesta").setup({
      theme = "dark",
      transparent = true,
    })
  end,
}
