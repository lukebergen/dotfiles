# start in home directory
cd

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

xcode-select --install

# base or personal. Depends on the machine
# brew bundle install --file Brewfile.base
# brew bundle install --file Brewfile.personal

# Chrome's auto-update stuff is such a pain in the ass if it's being managed
# by homebrew. Just install the dang package via a dmg
# brew cask install google-chrome

# grab all our dotfiles and link them up
git clone https://github.com/lukebergen/dotfiles.git
mv ./dotfiles ./.dotfiles

# todo: we should probably just ln the entire .config directory instead of all
# this piecemeal nonsense
mkdir ~/.config
ln -s ~/.dotfiles/nvim ~/.config
ln -s ~/.dotfiles/yazi ~/.config
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/hammerspoon ~/.hammerspoon

# byyyyeeee vim
#ln -s ~/.dotfiles/vim/rcs/vimrc ~/.vimrc
# mkdir -p ~/.vim
# ln -s ~/.dotfiles/vim/syntax ~/.vim

# some final git setup
git config --global user.name "Luke Bergen"
git config --global user.email lukeabergen@gmail.com
git config --global core.editor vim
git config --global init.templatedir '~/.dotfiles/git/git-templates'
