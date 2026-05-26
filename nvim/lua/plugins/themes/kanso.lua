return {
  "webhooked/kanso.nvim",
  lazy = false,
  priority = 1000, -- Garante que o tema carregue antes de outros plugins
  config = function()
    require("kanso").setup({
      -- Opções opcionais de customização aqui
      -- minimal = true, -- Ativa o modo de poucas cores
    })
  end,
}
