rbenv install 2.3.1

brew cask install java

brew install ctags
brew install elasticsearch
brew install gnupg
brew install go
brew install heroku-toolbelt
brew install keybase
brew install mercurial
brew install phantomjs
brew install postgresql
brew install redis
brew install tree
brew install wget
brew install node
brew install coreutils

brew services start elasticsearch
brew services start postgresql
brew services start redis

gem install bundler

# Probably something here to install latest version of python
pip install virtualenv
pip install virtualenvwrapper

# manually install node because fuck homebrew + npm
echo "if you need node on this box, install it/npm manually because I'm still figuring out automating that in a non-painful way"
