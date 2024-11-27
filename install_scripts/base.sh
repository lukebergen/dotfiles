# start in home directory
cd

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# git comes prepackaged on osx but let's grab the latest
brew install git
brew install rbenv
brew install the_silver_searcher
brew install vim
brew install neovim
brew install zsh
brew install fzf
brew install autojump
brew install glow

# finally, we can grab all our dotfiles and link them up
git clone https://github.com/lukebergen/dotfiles.git
mv ./dotfiles ./.dotfiles

# STOP: first time using cask so i does a thing
echo 'first time using cask so wait for that to do its GUI thing then press enter to continue'
read

brew cask install google-chrome

# install vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.dotfiles/vim/bundle/Vundle.vim

# install antigen
# Is this still needed?
# curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.dotfiles/zsh/antigen.zsh

# link everything up
# todo: we should probably just ln the entire .config directory instead of all this piecemeal nonsense
mkdir ~/.config
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/yazi ~/.config
ln -s ~/.dotfiles/vim/rcs/vimrc ~/.vimrc
mkdir -p ~/.vim
ln -s ~/.dotfiles/vim/syntax ~/.vim
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

brew install the_silver_searcher
brew install autojump
brew install vim
brew install ctags
brew install wget
brew install node
# brew install zsh (osx now defaults to this???)

brew install iterm2

# install vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.dotfiles/vim/bundle/Vundle.vim

# some final git setup
git config --global user.name "Luke Bergen"
git config --global user.email lukeabergen@gmail.com
git config --global core.editor vim
git config --global init.templatedir '~/.dotfiles/git/git-templates'
