PATH=$PATH:$HOME/bin:$HOME/System/prefix/bin:/usr/local/bin:/usr/local/sbin

sourceif()
{
    [[ -f $1 ]] && source $1
}

sourceif ~/.site.sh
sourceif ~/.site.zsh
source ~/.common.sh

sourceif ~/.profile
sourceif ~/.pyenv.sh
