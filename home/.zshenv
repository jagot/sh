PATH=$HOME/System/prefix/bin:/usr/local/bin:/usr/local/sbin:$PATH

sourceif()
{
    [[ -f $1 ]] && source $1
}

sourceif ~/.site.zsh
source ~/.common.sh
