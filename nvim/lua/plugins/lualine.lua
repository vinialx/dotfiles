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

        section_separators = {
          left = "",
          right = "",
        },

        component_separators = {
          left = "",
          right = "",
        },

        disabled_filetypes = {
          statusline = {
            "dashboard",
            "alpha",
            "starter",
          },
        },
      },

      sections = {
        lualine_a = {
          {
            "mode",
            separator = {
              left = "",
              right = "",
            },
          },
        },

        lualine_b = {
          {
            "branch",
            icon = "",
          },

          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
          },
        },

        lualine_c = {
          {
            "filename",
            path = 1,

            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = " [No Name]",
              newfile = " ",
            },
          },
        },

        lualine_x = {
          {
            "diagnostics",

            sources = {
              "nvim_diagnostic",
            },

            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = "󰌵 ",
            },
          },

          {
            function()
              local clients = vim.lsp.get_clients({
                bufnr = 0,
              })

              if #clients == 0 then
                return ""
              end

              local names = {}

              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end

              return " " .. table.concat(names, ", ")
            end,
          },

          {
            "filetype",
          },
        },

        lualine_y = {
          {
            "progress",
          },
        },

        lualine_z = {
          {
            "location",
            separator = {
              left = "",
              right = "",
            },
          },
        },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},

        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },

        lualine_x = {
          "location",
        },

        lualine_y = {},
        lualine_z = {},
      },

      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
