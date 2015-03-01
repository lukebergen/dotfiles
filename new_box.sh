# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew install ctags

brew cask install java
brew install elasticsearch
ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents

brew install git
brew install gnupg
brew install go
brew install heroku-toolbelt
brew install imagemagick
brew install keybase
brew install mercurial
brew install node
brew install nvm

brew install postgresql
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

brew install rbenv

brew install redis

brew install ruby-build
brew install the_silver_searcher
brew install vim
brew install wget
brew install zsh

brew cask install caffeine
brew cask install disk-inventory-x
brew cask install dropbox
brew cask install flux
brew cask install gas-mask
brew cask install gimp
brew cask install google-chrome
brew cask install gpgtools
brew cask install iterm2
brew cask install limechat
brew cask install onepassword
brew cask install skitch
brew cask install skype
brew cask install vlc
brew cask install whatsapp-pocket

gem install bundler
gem install jekyll

# install vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.dotfiles/vim/bundle/Vundle.vim

# install antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.dotfiles/zsh/antigen.zsh

# link everything up
ln -s ~/.dotfiles/vim/rcs/vimrc ~/.vimrc
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
