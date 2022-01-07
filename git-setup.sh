#!/bin/sh

EMAIL=$1

if [ -z "$EMAIL" ]; then
    echo "No email argument supplied"
    exit 1
fi

echo "Setting up global Git config"
git config --global user.name "Chace Anderson"
git config --global user.email "$EMAIL"
git config --global init.defaultBranch main

echo "Copying and assigning global .gitignore config"
# standard items for git to ignore
cp .gitignore $HOME/.gitignore
git config --global core.excludesfile $HOME/.gitignore

echo "Finished setting up Git config successfully"