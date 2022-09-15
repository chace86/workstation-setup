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

echo "Install Git and set up"
brew install git
brew link --overwrite git
sh git-setup.sh $EMAIL

echo "Setting up SSH key"
sh ssh-key-setup.sh $EMAIL

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

echo "Install JDK 8"
brew install openjdk@8
sudo ln -sfn $(brew --prefix)/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
java -version

echo "Install Scala 2.12"
brew install scala@2.12

echo "Install Python 3.8"
brew install python@3.8

echo "Install CLI tools"
brew tap aws/tap
brew install jq tree gh glab gradle@6 maven sbt awscli@2 aws-sam-cli

echo "Install applications"
brew install --cask docker visual-studio-code intellij-idea-ce postman dbeaver-community
brew install docker # Docker CLI needs to come after Docker Desktop
