############################################
# Misc
############################################

[ -d $HOME/bin ] && PATH=$PATH:$HOME/bin
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

export EDITOR=zile
export VISUAL=emacsclient

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
alias e="emacsclient --no-wait"
alias getpage='wget --wait=2 --no-parent -r -p -k'
[ "$(uname)" = "Linux" ] && alias pbcopy="xclip -sel clip"
[ "$(uname)" = "Linux" ] && alias pbpaste="xclip -o -sel clip"
alias lpdbl="lp -o sides=two-sided-long-edge"
alias pyserve="python3 -m http.server --bind localhost"

if type imgcat >/dev/null 2>&1; then
    alias dispimg="imgcat"
elif type feh >/dev/null 2>&1; then
    alias dispimg="feh -"
fi
alias qrpaste="pbpaste | qrencode -o - | dispimg"

# https://unix.stackexchange.com/a/277707
alias duplicatefiles="gfind . ! -empty -type f -exec md5sum {} + | gsort | guniq -w32 -dD"

############################################
# Termbin
############################################

# https://gist.github.com/schmich/f2ef5c85030863d630a97ec91c1b8eff

alias tb="nc termbin.com 9999"
alias encrypt="openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt"
alias decrypt="encrypt -d"
alias tbc="encrypt | tb"

function tbd {
    curl -s "http://termbin.com/$1" | decrypt
}

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

# https://stackoverflow.com/a/3278427/1079038
function git-multistatus {
    for i in *; do
        if [ -d "$i/.git" ]; then
            cd $i
            [ "$#" = "1" ] && [ "$1" = "-u" ] && git remote update > /dev/null
            LOCAL=$(git rev-parse @)
            REMOTE=$(git rev-parse @{u} 2>/dev/null)
            BASE=$(git merge-base @ @{u} 2>/dev/null)
            STATUS=$(git status --porcelain 2>&1 | wc -m | xargs)
            BRANCH=$(git branch --show-current)
            if [ "$BRANCH" = "master" ] || [ "$BRANCH" = "main" ]; then
                COLOR="\e[1m\e[32m"
            else
                COLOR="\e[1m\e[94m"
            fi
            NAME="$i @ $COLOR$BRANCH\e[0m"
            if [ "$LOCAL" = "$REMOTE" ]; then
                [ "$STATUS" != "0" ] && echo -e "$NAME"
            elif [ "$LOCAL" = "$BASE" ]; then
                echo -e "$NAME ⇣"
            elif [ "$REMOTE" = "$BASE" ]; then
                echo -e "$NAME ⇡"
            else
                echo -e "$NAME ⇅"
            fi
            [ "$STATUS" != "0" ] && git status -s && echo
            cd ..
        else
            echo "$i is not a Git directory"
        fi
    done
}

function magit {
    DIR=$1
    emacsclient --eval "(magit-status \"${DIR:=$(pwd)}\")"
}

function update-mirrorlist {
    if ! type "rate-mirrors" > /dev/null; then
        echo "Install rate-mirrors first"
        return 1
    fi

    TMPFILE="$(mktemp)"
    BACKUPFILE="/etc/pacman.d/mirrorlist.backup-$(date -I)"
    # https://stackoverflow.com/a/12187944
    # Not free from race conditions, naturally
    if [[ -e $BACKUPFILE || -L $BACKUPFILE ]] ; then
        i=1
        while [[ -e $BACKUPFILE-$i || -L $BACKUPFILE-$i ]] ; do
            let i++
        done
        BACKUPFILE=$BACKUPFILE-$i
    fi
    sudo touch -- $BACKUPFILE
    rate-mirrors --save=$TMPFILE arch --max-delay=43200 &&
        sudo mv /etc/pacman.d/mirrorlist $BACKUPFILE &&
        sudo mv $TMPFILE /etc/pacman.d/mirrorlist
}

download-clip() {
    # $1: url or Youtube video id
    # $2: starting time, in seconds, or in hh:mm:ss[.xxx] form
    # $3: duration, in seconds, or in hh:mm:ss[.xxx] form
    # $4: format, as accepted by youtube-dl (default: best)
    # other args are passed directly to youtube-dl; eg, -r 40K
    local fmt=${4:-best}
    local url="$(youtube-dl -g -f $fmt ${@:5} "$1")"
    local filename="$(youtube-dl --get-filename -f $fmt ${@:5} "$1")"
    ffmpeg -loglevel warning -hide_banner -stats \
        -ss $2 -i "$url" -c copy -t $3 "$filename"
    printf "Saved to: %s\n" "$filename"
    # based on Reino17's and teocci's comments in https://github.com/rg3/youtube-dl/issues/4821
}

killssh() {
    OPWD=$(pwd)
    cd ~/.ssh
    for i in socket*; do
        echo $i
        ssh -o ControlPath=$i -O check blah
        ssh -o ControlPath=$i -O exit blah
    done
    cd $OPWD
}
