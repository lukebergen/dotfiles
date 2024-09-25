-- todo: look into cleaner way to do this. Or at least do some research
-- or maybe just give in and use lualine (currently installed)
--vim.opt.statusline = '%f%m%=%l/%L:%c'

-- mmmmaaaaaassive todo: redo this in lua
--vim.cmd.colorscheme("lukes")

-- baked in color schemes
-- blue darkblue default delek desert elflord evening habamax industry koehler lukes lunaperche morning murphy pablo peachpuff quiet retrobox ron shine slate sorbet torte vim wildcharm zaibatsu zellner
--vim.cmd.colorscheme("wildcharm")
--vim.cmd.colorscheme("evening")
--vim.cmd.colorscheme("habamax")
--vim.cmd.colorscheme("slate")
--vim.cmd.colorscheme("sorbet")



--require("tokyonight").setup({
--  -- use the night style
--  style = "moon",
--  -- disable italic for functions
--  --styles = {
--  --  functions = {}
--  --},
--  --sidebars = { "qf", "vista_kind", "terminal", "packer" },
--  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--  --on_colors = function(colors)
--  --  colors.hint = colors.orange
--  --  colors.error = "#ff0000"
--  --end
--  -- doesn't seem to actually work. At least not for Normal
--  --on_highlights = function(hl, c)
--  --  hl.Normal = c.none
--  --end
--})


-- require('lualine').setup {
--   options = {
--     icons_enabled = false,
--     theme = 'gruvbox',
--     component_separators = { left = '|', right = '|'},
--     section_separators = { left = '|', right = '|'},
--     disabled_filetypes = {
--       statusline = {},
--       winbar = {},
--     },
--     ignore_focus = {},
--     always_divide_middle = true,
--     globalstatus = false,
--     refresh = {
--       statusline = 1000,
--       tabline = 1000,
--       winbar = 1000,
--     }
--   },
--   sections = {
-- --    lualine_a = {'mode'},
-- --    lualine_b = {'branch', 'diff', 'diagnostics'},
-- --    lualine_c = {'filename'},
-- --    lualine_x = {'encoding', 'fileformat', 'filetype'},
-- --    lualine_y = {'progress'},
-- --    lualine_z = {'location'}
--     lualine_a = {{'filename', path = 1}},
--     lualine_b = {'diff'},
--     lualine_c = {},
--     lualine_x = {'filetype'},
--     lualine_y = {'progress'},
--     lualine_z = {'location'}
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = {'filename'},
--     lualine_x = {'location'},
--     lualine_y = {},
--     lualine_z = {}
--   },
--   tabline = {},
--   winbar = {},
--   inactive_winbar = {},
--   extensions = {}
-- }

--vim.cmd("set notermguicolors")
--vim.cmd("colorscheme lukes")

--vim.cmd("hi Normal ctermbg=NONE")
--vim.cmd("hi NormalNC ctermbg=NONE")

--vim.cmd('set termguicolors')
--vim.cmd('set background=light')
--vim.cmd('colorscheme zenbones')


--vim.cmd("hi TabLineFill ctermfg=161 ctermbg=16")
--vim.cmd("hi TabLine ctermfg=Blue ctermbg=Yellow")
--vim.cmd("hi TabLineSel ctermfg=Red ctermbg=Yellow")
--vim.cmd("hi Title ctermfg=LightBlue ctermbg=Magenta")
--
--vim.cmd("hi TabLine guifg=#fadfc2 guibg=#7d8e7b gui=underline")
--vim.cmd("hi TabLineSel guifg=#ffffff guibg=#ef114a gui=bold,italic")
--vim.cmd("hi TabLineFill guifg=#2dbd1e guibg=#ffffff")
