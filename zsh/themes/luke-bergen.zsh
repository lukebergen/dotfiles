# Colors
typeset -A colors
colors=(
  white "\033[38;5;15m"
  blue "\033[38;5;4m"
  red "\033[38;5;1m"
  yellow "\033[38;5;11m"
  green "\033[38;5;2m"
  reset "\033[38;5;15m" # Just a shortcut for "white"
)


# Git prompt
function git_bit() {
  if [ -d .git ]; then
    STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
    BRANCH=$(command git rev-parse --abbrev-ref HEAD)

    if [ $BRANCH = "HEAD" ]; then
      BRANCH=$(git rev-parse --short HEAD)
    fi

    if [[ -n $STATUS ]]; then
      echo "$colors[blue]($colors[red]$BRANCH $colors[yellow]✗$colors[blue]) $colors[green]$ $colors[reset]"
    else
      echo "$colors[blue]($colors[red]$BRANCH $colors[green]√$colors[blue]) $colors[green]$ $colors[reset]"
    fi
  else
    echo "$colors[green]$ $colors[reset]"
  fi

  echo $result
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
