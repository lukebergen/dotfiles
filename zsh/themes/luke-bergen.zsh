# Colors
typeset -A colors
colors=(
  white "%{\033[38;5;15m%}"
  blue "%{\033[38;5;4m%}"
  #blue "%{\033[38;2;50;150;256m%}" # example of using RGB for even more granularity apparently
  red "%{\033[38;5;1m%}"
  yellow "%{\033[38;5;11m%}"
  green "%{\033[38;5;2m%}"
  reset "%{\033[0m%}"
)

# Git prompt
function git_bit() {
  git status > /dev/null 2>&1
  if [ $? = 0 ]; then
#startLoadTime=`gdate +%s.%N`
    #STATUS=$(git status --porcelain 2> /dev/null | tail -n1)
    STATUS=`git status --porcelain 2> /dev/null | tail -n1`
    #BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
#endLoadTime=`gdate +%s.%N`
#echo $(echo "$endLoadTime - $startLoadTime" | bc -l)

    if [ $BRANCH = "HEAD" ]; then
      BRANCH=$(git rev-parse --short HEAD 2> /dev/null)
      if [ $? = 128 ]; then
        BRANCH="<norev>"
      fi
    fi

    REPO=$(basename $(git remote show -n origin | grep Push | cut -d: -f2- | cut -d. -f2))
    if [[ $REPO = "origin" ]]; then
      REPO="untracked"
    fi

    if [[ -n $STATUS ]]; then
      echo "$colors[blue]($colors[red]$BRANCH $colors[yellow]✗$colors[blue]) $colors[green]$ $colors[reset]"
    else
      echo "$colors[blue]($colors[red]$BRANCH $colors[green]√$colors[blue]) $colors[green]$ $colors[reset]"
    fi
  else
    echo "$colors[green]$ $colors[reset]"
  fi
}

setopt promptsubst
PROMPT='%1~ $(git_bit)'

# Colors and completion stuff

LSCOLORS=Gxfxcxdxbxegedabagacad
LSCOLORS=exfxcxdxbxegedabagacad
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export COMPLETION_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

#zstyle ':completion:*:default' menu select
zstyle ':completion:*:default' menu select
zstyle ':completion:*:default' list-colors "${(@s.:.)COMPLETION_COLORS}"

#zstyle ':completion:*' menu select list-colors "${(@s.:.)LSCOLORS}"
autoload -Uz compinit
compinit
