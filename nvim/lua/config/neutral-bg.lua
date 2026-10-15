local function apply_neutral_background()
  local bg_alt = "#23232b"

  local groups = {
    Normal = { bg = "NONE" },
    NormalNC = { bg = "NONE" },

    SignColumn = { bg = "NONE" },
    EndOfBuffer = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },

    LineNr = { bg = "NONE" },
    CursorLineNr = { bg = bg_alt },

    StatusLine = { bg = "NONE" },
    StatusLineNC = { bg = "NONE" },

    WinBar = { bg = "NONE" },
    WinBarNC = { bg = "NONE" },

    NormalFloat = { bg = bg_alt },
    FloatBorder = { bg = bg_alt },

    Pmenu = { bg = bg_alt },
    PmenuSbar = { bg = bg_alt },

    TelescopeNormal = { bg = "NONE" },
    TelescopeBorder = { bg = "NONE" },
    TelescopePromptNormal = { bg = bg_alt },
    TelescopeResultsNormal = { bg = "NONE" },
    TelescopePreviewNormal = { bg = "NONE" },

    NeoTreeNormal = { bg = "NONE" },
    NeoTreeNormalNC = { bg = "NONE" },

    NvimTreeNormal = { bg = "NONE" },
    NvimTreeNormalNC = { bg = "NONE" },
  }

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(apply_neutral_background)
  end,
})

apply_neutral_background()
