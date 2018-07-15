############################################
# Misc
############################################

[ -d $HOME/bin ] && PATH=$PATH:$HOME/bin
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

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
alias e="emacsclient --no-wait"
alias getpage='wget --wait=2 --no-parent -r -p -k'

if type imgcat >/dev/null 2>&1; then
    alias qrpaste="pbpaste | qrencode -o - | imgcat"
fi

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

function lypwatch {
    lilypond "$1.ly"
    # open -a skim "$1.pdf" 2> /dev/null &
    e "$1.pdf"
    e "$1.ly"
    lyp watch "$1.ly"
}

function syncthing_remote {
    ssh -L "${2}:localhost:${3}" $1 &
    open http://localhost:$2
    sleep 0.1
    fg
}

function syncthing_home {
    syncthing_remote home 9090 8080
}

function prtar {
    [ $# -ne 2 ] && echo "Usage $0 <archive file> <directory>" && return 1
    extension="${1##*.}"
    case $extension in
        gz)
            compr=gzip
            ;;
        bz2)
            compr=bzip2
            ;;
        xz)
            compr=xz
            ;;
        *)
            echo "Unknown archive format, $extension" && return 1
            ;;
    esac
    tar cf - $2 | pv -s $(gdu -sb $2 | awk '{print $1}') | $compr > $1
}

function osc {
    rm -f $1.hpgl
    readtty /dev/tty.usbserial ";DF;" | pv > $1.hpgl
    rm -f $1.eps
    cat $1.hpgl | hp2xx -q -f- -m eps -a 2 > $1.eps
}

function pip-upgrade {
    pip install $(pip list --outdated --format=columns | tail -n +3 | awk '{print $1 }') --upgrade
}
