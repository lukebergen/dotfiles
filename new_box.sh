# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# STOP: (xcode will install some stuff now)

brew install ctags

brew cask install java

# STOP: first time using cask so it does a thing

brew install elasticsearch
ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist

brew install git
brew install gnupg
brew install go
brew install heroku-toolbelt
brew install imagemagick
brew install keybase
brew install mercurial

# manually install node because fuck homebrew + npm

brew install phantomjs

brew install postgresql
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

brew install rbenv

brew install redis
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist

brew install ruby-build
brew install the_silver_searcher
brew install vim
brew install wget
brew install zsh

brew cask install caffeine
brew cask install disk-inventory-x
brew cask install dropbox
brew cask install flint
brew cask install flux
brew cask install gas-mask
brew cask install gimp
brew cask install google-chrome
brew cask install gpgtools

# STOP: requires password

brew cask install iterm2
brew cask install limechat
brew cask install 1password
brew cask install screenhero
brew cask install skitch
brew cask install slack
brew cask install skype
brew cask install vlc
brew cask install whatsapp-pocket


# STOP: install most recent version of ruby
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
ln -s ~/.dotfiles/.Rprofile ~/.Rprofile
ln -s ~/.dotfiles/irbrc ~/.irbrc
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

# some final up
git config --global user.name "Luke Bergen"
git config --global user.email lukeabergen@gmail.com
git config --global core.editor vim
git config --global init.templatedir '~/.dotfiles/git/git-templates'
