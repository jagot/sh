# Without this Tramp will hang
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

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
setopt AUTO_CD

autoload colors
colors

# You can change the names/locations of these if you prefer.
antidote_dir=${ZDOTDIR:-~}/.antidote
plugins_txt=${ZDOTDIR:-~}/.zsh_plugins.txt
static_file=${ZDOTDIR:-~}/.zsh_plugins.zsh

# Clone antidote if necessary and generate a static plugin file.
if [[ ! $static_file -nt $plugins_txt ]]; then
  [[ -e $antidote_dir ]] ||
    git clone --depth=1 https://github.com/mattmc3/antidote.git $antidote_dir
  (
    source $antidote_dir/antidote.zsh
    [[ -e $plugins_txt ]] || touch $plugins_txt
    antidote bundle <$plugins_txt >$static_file
  )
fi

# Uncomment this if you want antidote commands like `antidote update` available
# in your interactive shell session:
# autoload -Uz $antidote_dir/functions/antidote

# source the static plugins file
source $static_file

# cleanup
unset antidote_dir plugins_txt static_file

if [ "$TERM" != "dumb" ]; then
    source ~/.zsh/zsh-dircolors-solarized/zsh-dircolors-solarized.zsh
    setupsolarized dircolors.ansi-dark
    LS="ls"
    [[ "$(uname)" == "Darwin" ]] &&  LS="gls"
    alias ls='$LS -G -h --color=auto'
fi

[[ $TERM == eterm-color ]] && export TERM=xterm

sourceif()
{
    [[ -f $1 ]] && source $1
}

sourceif ~/.iterm2_shell_integration.zsh
sourceif ~/.fzf.zsh
