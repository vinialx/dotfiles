return {
  "nvim-lualine/lualine.nvim",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  event = "VeryLazy",

  config = function()
    require("lualine").setup({
      options = {
        theme = "base16",
        globalstatus = true,

        component_separators = {
          left = "",
          right = "",
        },

        section_separators = {
          left = "",
          right = "",
        },
      },

      sections = {
        lualine_a = {
          "mode",
        },

        lualine_b = {
          "branch",
        },

        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },

        lualine_x = {
          "diagnostics",
          "filetype",
        },

        lualine_y = {
          "progress",
        },

        lualine_z = {
          "location",
        },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          "filename",
        },
        lualine_x = {
          "location",
        },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
