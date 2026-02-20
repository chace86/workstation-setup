#!/bin/sh

# An email required for setting up Git and SSH
EMAIL=$1

if [ -z "$EMAIL" ]; then
    echo "No email argument supplied"
    exit 1
fi

echo "Checking if Xcode CommandLineTools installed"
which -s xcodebuild
if [[ $? != 0 ]] ; then
    # Xcode installs Git
    xcode-select --install
else
    echo "Xcode CommandLineTools already installed"
fi

# Install Homebrew if needed
# Homebrew seems to require Git with user.name and user.email configured
echo "Checking to see if Homebrew needs to be installed"
which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew already installed. Updating Homebrew."
    brew update
fi

echo "Install Brewfile tools via Homebrew"
brew bundle install

echo "Create Java 8 symlink"
sudo ln -sfn $(brew --prefix)/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk

echo "Add JDKs and set jenv global"
jenv add /Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home
jenv global 1.8 # set sbt to use jdk 8

echo "Set up coursier"
cs setup

echo "Install Git and set up"
brew install git
brew link --overwrite git
sh git-setup.sh $EMAIL

echo "Setting up SSH key"
sh ssh-key-setup.sh $EMAIL

echo "Install Oh My Zsh"
# https://sourabhbajaj.com/mac-setup/iTerm/zsh.html
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Syntax highlighting, auto-suggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# sane defaults, aliases, functions, auto-completion, prompt themes
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

echo "Setting zsh as default shell. You may need to restart your machine for changes to take effect"
chsh -s $(which zsh)

# Copy zsh config files
cp ./zsh/.zlogin ~/.zlogin
cp ./zsh/.zlogout ~/.zlogout
cp ./zsh/.zpreztorc ~/.zpreztorc
cp ./zsh/.zprofile ~/.zprofile
cp ./zsh/.zshenv ~/.zshenv
cp ./zsh/.zshrc ~/.zshrc
