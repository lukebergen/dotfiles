# Handoff: Dotfiles Cleanup Session

## Context

We just finished a syncing session — three diverged branches (desktop/lappy/work) were merged into
a new `synced` branch in the dotfiles repo at `~/.dotfiles`. The config is now in decent shape
across all three machines.

The next session is a **cleanup pass**: trimming years of accumulated experiments, disabled plugins,
dead keymaps, and commented-out blocks. The framing question is: "what would we delete if we were
starting fresh today?"

---

## The Big Theme: Copilot → Claude

The most impactful cleanup thread. Copilot is now disabled on all three machines (`return {}` in
`copilot.lua`). But its fingerprints are all over the config:

- **`nvim/lua/plugins/copilot.lua`**: 130 lines of commented-out config. Could just be emptied to
  `return {}` with a one-line comment if copilot is truly gone.
- **`nvim/lua/plugins/lsp.lua`**: `<leader>xcd` keymap ("ask CopilotChat about diagnostic") calls
  `require("CopilotChat")` which no longer exists. Dead keymap — will error if triggered.
- **`nvim/lua/plugins/nvim-cmp.lua`**: `<C-s>` mapping has copilot suggestion logic
  (`copilot.suggestion.is_visible()`) — also dead now.
- **`zsh/zshrc`**: `alias node_insecure=node` — this exists specifically because copilot needed a
  node without cert validation. If copilot is gone, this alias has no purpose.
- **`bin/bun_insecure`**: same story, work-machine cert workaround for copilot-era tooling. Check
  if anything else actually uses it.
- **`install_scripts/Brewfile.base`**: no copilot entry, but worth a pass anyway.

The replacement (Claude/`quickcode.lua`/`msc()`) is already in place. This is just cleanup.

---

## Specific Cleanup Candidates

### nvim/lua/luke/init.lua
The bottom half of this file is a never-finished experiment — a raw plenary.curl streaming call to
ollama with a `TestNewThing` command. It was scaffolding that never got promoted to a real feature.
The `llm.lua` module handles this properly now (guarded by `CODE_LLM=ollama`). The dead code:

```lua
local curl = require('plenary.curl')
local function streamResponse() ... end
vim.api.nvim_create_user_command('TestNewThing', streamResponse, {})
```

### nvim/lua/plugins/neotest.lua
Has `enabled = false` and a TODO at line 1: "get this (or something like it) working". It has
never worked. Either invest in getting it working or delete it. It's been dormant a long time.

### nvim/lua/plugins/strudel.lua + nvim/ftdetect/str.lua
Strudel live-coding plugin. Worth asking: is this an active interest or a past experiment? If you
haven't opened a `.str` file in months, delete both.

### hammerspoon/init.lua — large commented blocks
Two big `--[[ ... ]]` blocks that were explicitly deprecated during the sync:
- `--[[ OLD MODAL-BASED CLIPBOARD SYSTEM ... ]]` — replaced by the new state-based system
- `--[[ KITTY HOTKEY WINDOW (currently broken) ... ]]` — never got working

These can just be deleted entirely. The new implementations are active above them.

### zsh/zshrc — commented assist_win/assist_vim block
Four lines of commented-out aliases for a floating kitty assistant window experiment that "never
came up as clean as I want it to be". Been commented out for a long time.

### nvim/lua/luke/keymaps.lua — NextSearchResult
A custom `n`/`N` implementation with a comment "TODO: figure out why this sometimes causes results
to look like [1/50] => [3/50]...". The keymaps for it are commented out. Either fix it or delete
the function.

### nvim/lua/plugins/lsp.lua — ts_ls diagnostic handler
A commented-out custom handler for ignoring ts_ls error code 80001. There's a commit in history
("oh.. So there is a baked in way to ignore ts_ls codes") suggesting this was superseded by a
native approach. The commented block is dead weight.

---

## Brewfile.base Audit

Worth a pass. Some suspects:
- `brew "autojump"` — replaced by zoxide. Still installed?
- `brew "the_silver_searcher"` — replaced by ripgrep (`rg`). Still used?
- `brew "mdcat"` — is `glow` (which you have and use via `alias md='glow -'`) the preferred tool now?
- `brew "iterm2"` — you're on kitty/wezterm. Still need this cask?
- `brew "plantuml"` — actively used?
- `brew "flyctl"` — actively used?
- `brew "redis"` — do all machines need this running as a service?
- `brew "python@3.10"` and `brew "python@3.11"` — both? Are both actually needed as deps?

---

## Smaller Things Worth Noting

- **`nvim/lua/luke/llm.lua`**: The ollama LLM buffer plugin. It works (guarded by `CODE_LLM=ollama`
  env var), but it's unclear how actively it's used vs. just using Claude Code externally. Not
  necessarily dead, but worth a "do I actually use this?" check.

- **`zsh/zshrc` opam block**: A multi-line commented block for opam (OCaml package manager) at the
  bottom. There was an "ocaml stuff" commit phase in the history. Is OCaml still a thing?

- **`bin/` directory**: A few scripts worth reviewing — `mn.bak`, `pai`, `quiltflower`,
  `quiltflower-1.8.1.jar`. Some of these look like they might be old project-specific tools.

---

## Approach Suggestion for the Session

Go file by file rather than theme by theme — it's easier to make a decision when you can see the
full file. Suggested order:
1. `nvim/lua/luke/init.lua` (quick win — TestNewThing is obvious dead code)
2. `nvim/lua/plugins/copilot.lua` (one decision: keep the config commented or delete it)
3. `nvim/lua/plugins/neotest.lua` (keep or delete)
4. `nvim/lua/plugins/lsp.lua` (dead copilot keymap, dead ts_ls handler)
5. `nvim/lua/luke/keymaps.lua` (NextSearchResult)
6. `hammerspoon/init.lua` (delete the two big deprecated blocks)
7. `zsh/zshrc` (assist_win comments, opam block, node_insecure if copilot gone)
8. `install_scripts/Brewfile.base` (audit pass)
9. `bin/` directory (quick audit)
10. `nvim/lua/plugins/strudel.lua` (keep or delete — depends on current interest)
