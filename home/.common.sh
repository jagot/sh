############################################
# Misc
############################################

[ -d $HOME/bin ] && PATH=$PATH:$HOME/bin

EDITOR=zile
VISUAL=emacs

HISTCONTROL=ignoredups
HISTCONTROL=ignoreboth

if [[ "$(uname)" == "Darwin" ]]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
fi

export GCC_COLORS=1

############################################
# Aliases
############################################

alias rsyncaz='rsync -az --info=progress2'
alias rsyncrz='rsync -rlDz --info=progress2'
alias tb="nc termbin.com 9999"

############################################
# Functions
############################################

function notebookserver {
    [ $# -eq 0 ] && pynbdir="$HOME/Sync/ipynb" || pynbdir="$1"
    ordir=$(pwd)
    cd "$pynbdir"
    jupyter notebook --no-browser
    cd "$ordir"
}

function ipythonqt {
    ipython3 qtconsole --matplotlib=inline --IPythonQtConsoleApp.hide_menubar=True
}
