# Machine-specific setup for the `synced` branch

After pulling this branch on each machine, you'll need to do a few manual steps to handle things
that are machine-specific and intentionally not in the shared config.

---

## Desktop (CachyOS/Linux)

- **kitty config**: Symlink to the Linux kitty config instead of the macOS one:
  ```
  ln -sf ~/.dotfiles/kitty/kitty-linux.conf ~/.config/kitty/kitty.conf
  ```

---

## Lappy (macOS)

- **kitty config**: Symlink to the standard kitty config:
  ```
  ln -sf ~/.dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
  ```

---

## Work (macOS)

- **kitty config**: Symlink to the standard kitty config:
  ```
  ln -sf ~/.dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
  ```

- **Machine-specific shell exports**: Create `~/.local/share/zsh/post.zsh` with work-specific
  settings (these were removed from the shared `zshrc`):
  ```zsh
  source ~/code/venv/bin/activate
  export NODE_EXTRA_CA_CERTS=$HOME/.pki/mm-cert-bundle.pem
  ```

---

## Neovim version

The neovim config is now targeting nvim **0.12+** (treesitter config, `vim.uv` API, etc).

- **Desktop**: already on 0.12 ✓
- **Lappy** and **Work**: need to upgrade nvim before using this branch. Use your package manager
  (homebrew: `brew upgrade neovim`).

`tree-sitter-cli` must also be installed before launching neovim — it's needed to compile treesitter
parsers. It's in `Brewfile.base` but install it manually if you're not doing a full fresh setup:
```
brew install tree-sitter tree-sitter-cli
```
(`tree-sitter` is the library, `tree-sitter-cli` is the compiler — both are needed.)

---

## Vimwiki path change

The markdown vimwiki path changed from `~/.vimwiki-md` to `~/.vimwiki` (to match the non-markdown
wiki). If you have an existing wiki at `~/.vimwiki-md`, rename it:
```
mv ~/.vimwiki-md ~/.vimwiki
```
This applies to any machine that was using `WIKI_FORMAT=md`.

---

## lazy-lock.json (neovim plugin lockfile)

The committed `lazy-lock.json` reflects the state on desktop. When you first boot neovim on Lappy
or Work after switching to this branch, run `:Lazy sync` to update plugins to match the lockfile,
then `:Lazy update` if you want to bring everything current (and commit the new lockfile).

---

## Notes

- `~/.local/share/zsh/pre.zsh` and `~/.local/share/zsh/post.zsh` are sourced by `zshrc` if they
  exist. Use these for any machine-specific shell config that shouldn't be committed.
