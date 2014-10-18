# install ohmyzsh
curl -L http://install.ohmyz.sh | sh

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install caskroom/cask/brew-cask

brew install ctags
brew install elasticsearch
brew install git
brew install gnupg
brew install go
brew install imagemagick
brew install mercurial
brew install node
brew install nvm
brew install postgresql
brew install rbenv
brew install redis
brew install the_silver_searcher
brew install vim
brew install wget
brew install zsh
brew install z

brew cask install google-chrome
brew cask install dropbox
brew cask install onepassword

ln -s ~/.vim.rc ~/.dotfiles/vim/rcs/vimrc
ln -s ~/.zsh.rc ~/.dotfiles/zsh/zshrc
