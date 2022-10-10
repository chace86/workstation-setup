# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export GRADLE_HOME=/usr/local/opt/gradle@6/libexec
export SCALA_HOME=/usr/local/Cellar/scala@2.12/2.12.17
export PATH=$HOME/.jenv/bin:$PATH:$GRADLE_HOME/bin:$SCALA_HOME/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="robbyrussell"

plugins=(git colored-man-pages colorize pip python brew macos)

export LANG=en_US.UTF-8
export EDITOR=vim

# Aliases
alias python=/usr/local/bin/python3.8

source $ZSH/oh-my-zsh.sh
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

eval "$(jenv init -)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
