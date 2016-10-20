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

source <(antibody init)

antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle zsh-users/zsh-history-substring-search
antibody bundle supercrabtree/k
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure

[[ $TERM == eterm-color ]] && export TERM=xterm
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' # Without this Tramp will hang

[[ -f ~/.profile ]] && source ~/.profile
