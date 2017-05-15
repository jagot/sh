############################################
# Misc
############################################

EDITOR='emacs -nw'

HISTCONTROL=ignoredups
HISTCONTROL=ignoreboth


ulimit -c unlimited # No limit on core dump file size

############################################
# Aliases
############################################

alias rsyncaz='rsync -az --info=progress2'
alias rsyncrz='rsync -rlDz --info=progress2'

############################################
# Functions
############################################

function notebookserver {
    [ $# -eq 0 ] && pynbdir="$HOME/Dropbox/ipynb" || pynbdir="$1"
    ordir=$(pwd)
    cd "$pynbdir"
    ipython3 notebook --no-browser --deep-reload --pylab=inline
    cd "$ordir"
}

function ipythonqt {
    ipython3 qtconsole --matplotlib=inline --IPythonQtConsoleApp.hide_menubar=True
}
