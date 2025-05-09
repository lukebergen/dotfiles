# README

This is easily one of the more complicated sections of this dotfiles repo. So giving it it's own readme with a bunch of neovim specific info

## Configuration structure

- init.lua        - main entry point. The file neovim runs at startup
- lazy-lock.json  - a lockfile for all our plugins. Similar to a package-lock.json file
- notes.md        - this file
- colors/         - defunct. Carry-over from before we migrated to neovim
- lua/            - all the helpers/more specific stuff. init.lua mostly just executes these
  - plugins/      - all our plugin specs. See [plugins](#plugins) below
  - commands.lua  - this is where I put all my user defined commands like :Xml, :Rg, etc...
  - keymaps.lua   - all my personal keybindings
  - plug.lua      - mostly just a wrapper around ensuring that lazy.nvim is loaded and then telling it to look to the plugins/ folder for plugin specs
  - settings.lua  - for settings/options like indentation width, etc
  - styles.lua    - defunct. Using nightfox colorscheme now (long-term dreams of making my own custom colorscheme with lush.nvim)
- syntax/         - defunct. Was only using it for plantuml syntax definitions. But we handle that with treesitter and a plantuml specific plugin

## Plugins

### Random notes
Each file under the lua/plugins/ directory is a lazy-nvim plugin spec. See [lazy-nvim spec](https://lazy.folke.io/spec) documentation for more info.

In the spec, the init function is run before the plugin loads even if the the plugin is configured to load lazily. The config function is run after the plugin has loaded.

### Plugins installed
- auto-session - manages automatically saving/reloading sessions for a given working directory
- fugitive     - :replace-me: old git plugin
- hop          - handy little plugin to make it easy to jump to specific places in a buffer
- init         - required as the starting point for all the other plugins I guess?
- nightfox     - colorscheme jazz
- polyglot     - syntax/highlight files. Mostly just for old/obscure things that don't have tree-sitter support for yet
- surround     - :replace-me: ? (with echasnovski/mini.surround) handy key mappings to surround words with quotes, change parens to brackets, etc. See its docs for more
- telescope    - :must-have: fuzzy finder over lists. That's super generic. Just check out the [docs](https://github.com/nvim-telescope/telescope.nvim) for all the handy stuff you can do with it. (I use `ff` a hundred times a day)
  - telescope-media-files (for showing previews of media files (images require chafa binary to be installed))
- treesitter   - experimental at this point but seems like the future of syntax-based stuff like highlighting and whatnot
- unimpaired   - some handy key mappings. See [docs](https://github.com/tpope/vim-unimpaired) for everything. I mostly just use it for `]q`, `[q`, `]s`, and `[s`
- vimwiki      - :replace-me: ? A bunch of bindings and all kinds of stuff to make it easy to manage a little wiki for note taking, diary, task management, etc. Maybe replace with kiwi if I can reproduce everything I like about the old school vimwiki?


### To look into
- pwntester/octo.nvim
- nvim-telekasten/telekasten.nvim (vimwiki replacement?)
  - calendar-vim
- mistweaverco/kulala.nvim
- L3MON4D3/LuaSnip

## Some Handy Built-in and Plugin Commands

:Inspect         =>  inspect syntax/highlight group of whatever the cursor is currently on (useful for changing colors in the colorscheme)
:InspectTree     => show the treesitter parse of the current buffer (not _super_ useful for anything, but pretty cool)
:Lazy            => bring up the Lazy plugin manager interface
:SessionSave     => save the current session (saves based on pwd)
:SessionRestore  => load the saved session (if one exists) based on pwd

---

Random stuff that's either new (to me) enough that I don't have it in muscle memory yet or I use it infrequently enough that I forget it...

Or just new mappings that I'm trying for myself.

- gc => commenting
- ga => encoding info (ascii, hex, octal, utf)
- K => look up info about thing under cursor (K again to enter the float window if it requires scrolling or searching)
- z => fold stuff
  - not builtin, but <leader>xf => toggle between foldmethod=indent and manual
  - zc => close whatever fold the cursor is currently in
  - zo => open fold
  - zM => close all folds
  - zR => open all folds
  - in manual fold method...
    - zf => motion or visual: create fold
    - zd => delete current fold
    - zE => delete all folds (in buffer? in window?)
- <leader>xg => toggle git signs (maybe check out zen mode though?)
- if helpfile looks bland: check ft and `set ft=help` if it isn't already
- verbose command SomeCommand => can't figure out where `SomeCommand` comes from? Try this

Hate the neovim pager or want to do somethign with a command output?

```
:redir @x<CR>
:someCommand<CR>
"xp
:redir END
```

after running `:redir @{register}<CR>` anything that outputs text will instead be written to the `x` register (or whichever you specify). Redir can also take a file if you want to write to an actual file instead of a temp thing like a register. (obviously, see `h redir` for all the deets)
