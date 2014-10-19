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
brew cask install whatsapp-pocket

# install ohmyzsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.dotfiles/zsh/oh-my-zsh
cp ~/.dotfiles/zsh/themes/lukebergen.zsh-theme ~/.dotfiles/zsh/oh-my-zsh/themes/

# link everything up
ln -s ~/.vim.rc ~/.dotfiles/vim/rcs/vimrc
ln -s ~/.zsh.rc ~/.dotfiles/zsh/zshrc
