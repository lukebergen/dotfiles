My collection of dotfiles for vim, zsh, and eventually others.

Also includes an install.sh file for new machines.

Also, looooooootta keymaps break for various tools if MacOS has already laid claim to them. Check `Preferences > Keyboard > Keyboard Shortcuts > (all of the things)` for OS-level keymappings to turn on/off if they collide or just aren't wanted.

TODO:
- look into replacing autojump with zoxide (yazi prefers it and I guess it's faster?)
- fix up install_scripts. So many `brew install` this that and the other. But we haven't kept it up to date. So, updated it (neovim, yazi, glow, miller, hexyl)
- figure out why yazi hexyl plugin isn't working for binary hex previews
- kitty term equivalent of the iTerm cmd+shift+c for a global hotkey window
- document the shit out of everything
- fix annoying thing where git config automatically gets tweaked on mm machine by the local pre zsh script (no clue how to do this. Think about it) (can you do gitconfig on a repo by repo level? That could solve the annoyance where I have to log in per-repo. Just have the default be old-school-style and have new repos use the new thing)
- figure out a way to search in kitty (kitty_mod+g looks promising, but doesn't seem to be the full result of the last command)
- rejigger neovim config under luke/. Splitting things by keymap vs command vs etc doesn't make as much sense as it once did. Maybe split things up by function/section (navigation, layout, utils?, etc)
