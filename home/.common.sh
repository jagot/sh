############################################
# Misc
############################################

EDITOR='emacs -nw'

HISTCONTROL=ignoredups
HISTCONTROL=ignoreboth

if [ "$TERM" != "dumb" ]; then
    alias ls='ls -G -h'
    LS_COLORS='di=38;5;108:fi=00:*svn-commit.tmp=31:ln=38;5;116:ex=38;5;186'
fi

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
