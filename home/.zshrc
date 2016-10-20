unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' special-dirs true
zstyle -s ':completion:*:hosts' hosts _ssh_config
[[ -r ~/.ssh/config ]] && _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
zstyle ':completion:*:hosts' hosts $_ssh_config
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

setopt NO_HUP
setopt NO_CHECK_JOBS

autoload colors
colors

source ~/.antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle git
antigen bundle git-flow-avh
antigen bundle arialdomartini/oh-my-git
antigen theme arialdomartini/oh-my-git-themes arialdo-granzestyle
antigen bundle tmux
antigen bundle supercrabtree/k

antigen-apply

[[ $TERM == eterm-color ]] && export TERM=xterm
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' # Without this Tramp will hang

[[ -f ~/.profile ]] && source ~/.profile
