############################################
# Misc
############################################

EDITOR='emacs -nw'

HISTCONTROL=ignoredups
HISTCONTROL=ignoreboth



############################################
# Aliases
############################################

alias rsyncaz='rsync -az --info=progress2'
alias rsyncrz='rsync -rlDz --info=progress2'

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
