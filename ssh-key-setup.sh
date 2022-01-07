#!/bin/sh

EMAIL=$1

if [ -z "$EMAIL" ]; then
    echo "No email argument supplied"
    exit 1
fi

# check if ssh key already exists
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  echo "SSH Key already exists. Skipping SSH Key Generation."
  exit 0
fi

# generate ssh key using ed25519 algorithm
# -C set email, -N empty passcode, -q quiet
ssh-keygen -q -t ed25519 -C "$EMAIL" -f $HOME/.ssh/id_ed25519 -N ""

# start ssh-agent in the background
eval "$(ssh-agent -s)"

# add ssh key
ssh-add -K $HOME/.ssh/id_ed25519

# print public key to add
echo "SSH Key created and added to agent. Add public key to remote (GitHub, GitLab, etc.)"
echo "Public Key:"
cat $HOME/.ssh/id_ed25519.pub