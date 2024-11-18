--[[
  palette: (https://github.com/EdenEast/nightfox.nvim/blob/main/lua/nightfox/palette/terafox.lua)
    Shade: [base, bright, dim, ?light?]

    black   = Shade.new("#2F3239", "#4e5157", "#282a30"),
    red     = Shade.new("#e85c51", "#eb746b", "#c54e45"),
    green   = Shade.new("#7aa4a1", "#8eb2af", "#688b89"),
    yellow  = Shade.new("#fda47f", "#fdb292", "#d78b6c"),
    blue    = Shade.new("#5a93aa", "#73a3b7", "#4d7d90"),
    magenta = Shade.new("#ad5c7c", "#b97490", "#934e69"),
    cyan    = Shade.new("#a1cdd8", "#afd4de", "#89aeb8"),
    white   = Shade.new("#ebebeb", "#eeeeee", "#c8c8c8"),
    orange  = Shade.new("#ff8349", "#ff9664", "#d96f3e"),
    pink    = Shade.new("#cb7985", "#d38d97", "#ad6771"),

    comment = "#6d7f8b",

    bg0     = "#0f1c1e", -- Dark bg (status line and float)
    bg1     = "#152528", -- Default bg
    bg2     = "#1d3337", -- Lighter bg (colorcolm folds)
    bg3     = "#254147", -- Lighter bg (cursor line)
    bg4     = "#2d4f56", -- Conceal, border fg

    fg0     = "#eaeeee", -- Lighter fg
    fg1     = "#e6eaea", -- Default fg
    fg2     = "#cbd9d8", -- Darker fg (status line)
    fg3     = "#587b7b", -- Darker fg (line numbers, fold colums)

    sel0    = "#293e40", -- Popup bg, visual selection bg
    sel1    = "#425e5e", -- Popup sel bg, search bg
--]]

return {
  {
    "EdenEast/nightfox.nvim", version = "*",
    config = function()

      -- let s:lightcyan   = { "gui": "#AFD7D7", "cterm": "152" }
      -- let s:dimwhite    = { "gui": "#9E9E9E", "cterm": "247" }

      -- not terribly useful since I can't then make use of these new custom colors... :(
      -- actually, working now. Either needed to upgrade to latest version OR, seems like "palette.<colorname>" maybe?
      -- e.g. `netrwDir = { fg = "palette.magenta.dim" }` works
      local palettes = {
        all = {
          dimwhite = "#9e9e9e",
          lightcyan = "#afd7d7",
        }
      }

      local groups = {
        all = {
          WinSeparator = { fg = "bg3", bg = NONE },
          Normal = { fg = "fg1", bg = "NONE",  },
          NormalNC = { fg = "fg1", bg = "NONE" },
          TabLine = { fg = "black", bg = "fg2" },
          TabLineSel = { fg = "white", bg = "NONE" },
          TabLineFill = { fg = "black", bg = "fg2" },
          StatusLine = { fg = "white", bg = "fg3" },
          StatusLineNC = { fg = "white", bg = "sel0" },
          --StatusLine = { fg = "bg3", bg = "lightcyan" },
          CursorLine = { bg = "bg1" },
          --netrwDir = { fg = "palette.magenta.dim" },
          netrwDir = { fg = "palette.blue.bright" },
          netrwExe = { fg = "palette.red.bright" },
          MatchParen = { fg = "palette.red.bright" },
          gitcommitSummary = { fg = "palette.blue.bright" },
          HopNextKey = { fg = "palette.red.bright" },
          SpecialKey = { bg = "palette.magenta.bright", fg = "palette.white.bright" },
          -- TODO: come back to this and figure out how to make it highlight todos but not in the dumb way where you can't even read it
          ["@text.todo.comment"] = { bg = "palette.blue.dim", fg = "palette.white.bright" },
--          ["@comment.error"] = { fg = "palette.fg1", bg = "palette.bg3" }, -- error-type comments (e.g. `ERROR`, `FIXME`, `DEPRECATED:`)
--          ["@comment.warning"] = { fg = "palette.bg1", bg = "palette.diag.warn" }, -- warning-type comments (e.g. `WARNING:`, `FIX:`, `HACK:`)
--          ["@comment.todo"] = { fg = "palette.bg1", bg = "palette.diag.hint" }, -- todo-type comments (e.g. `TODO:`, `WIP:`, `FIXME:`)
--          ["@comment.note"] = { fg = "palette.bg1", bg = "palette.diag.info" }, -- note-type comments (e.g. `NOTE:`, `INFO:`, `XXX`)
        }
      }

      require("nightfox").setup({palettes = palettes, groups = groups})

        -- TODO: bug report this. If I override (or create a new) color in the palette, why can't I then make use of that in groups?
        --require("nightfox").setup({
        --  palettes = {
        --    terafox = {
        --      red = "#00FF00", -- Your custom color
        --      -- Add other color overrides here
        --    },
        --  },
        --  groups = {
        --    terafox = {
        --      WinSeparator = { fg = "red", bg = "red" },
        --      StatusLine = { fg = "black", bg = "red" }
        --    }
        --  }
        --})

      vim.cmd('set termguicolors')
      vim.cmd('set background=dark')
      vim.cmd('colorscheme terafox')

      -- color overrides
      --vim.cmd("hi Normal guibg=NONE")
      --vim.cmd("hi NormalNC guibg=NONE")
      --vim.cmd("hi VertSplit guifg=#ffffff guibg=#ffffff")
      -- vim.cmd("hi WinSeparator guifg=orange")
    end
  }
}
