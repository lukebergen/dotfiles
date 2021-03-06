# Grab the dotfiles repo
cd
git clone https://github.com/lukebergen/dotfiles.git
mv ./dotfiles ./.dotfiles

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# git comes prepackaged on osx but let's grab the latest
brew install git
brew install rbenv
brew install the_silver_searcher
brew install vim
brew install zsh
brew install autojump

brew cask install iterm2

# STOP: first time using cask so i does a thing
echo 'first time using cask so wait for that to do its GUI thing then press enter to continue'
read

brew cask install google-chrome

# install vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.dotfiles/vim/bundle/Vundle.vim

# install antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.dotfiles/zsh/antigen.zsh

# link everything up
ln -s ~/.dotfiles/vim/rcs/vimrc ~/.vimrc
mkdir -p ~/.vim
ln -s ~/.dotfiles/vim/syntax ~/.vim
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
ln -s ~/.dotfiles/.Rprofile ~/.Rprofile
ln -s ~/.dotfiles/irbrc ~/.irbrc
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/gitconfig ~/.agignore

# some final up
git config --global user.name "Luke Bergen"
git config --global user.email lukeabergen@gmail.com
git config --global core.editor vim
git config --global init.templatedir '~/.dotfiles/git/git-templates'
