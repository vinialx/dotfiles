return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local gs = require("gitsigns")

      vim.keymap.set("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Next Git Hunk" })

      vim.keymap.set("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Previous Git Hunk" })

      vim.keymap.set("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage Hunk" })
      vim.keymap.set("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk" })
      vim.keymap.set("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })

      vim.keymap.set("v", "<leader>ghs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage Selected Hunk" })

      vim.keymap.set("v", "<leader>ghr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset Selected Hunk" })

      vim.keymap.set("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
      vim.keymap.set("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })

      vim.keymap.set("n", "<leader>ghb", function()
        gs.blame_line({ full = true })
      end, { desc = "Blame Line" })

      vim.keymap.set("n", "<leader>ghB", gs.blame, { desc = "Blame Buffer" })

      vim.keymap.set("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })

      vim.keymap.set("n", "<leader>ghD", function()
        gs.diffthis("~")
      end, { desc = "Diff Against ~" })

      vim.keymap.set("n", "<leader>ght", gs.toggle_deleted, { desc = "Toggle Deleted Lines" })

      return opts
    end,
  },
}
