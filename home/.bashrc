PATH=$PATH:$HOME/bin:$HOME/System/prefix/bin:/usr/local/bin:/usr/local/sbin

sourceif()
{
    [[ -f $1 ]] && source $1
}

sourceif $HOME.alias
sourceif $HOME/.homesick/repos/homeshick/homeshick.sh
sourceif $HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash

sourceif ~/.site.sh
source ~/.common.sh

sourceif ~/.profile
sourceif ~/.pyenv.sh
