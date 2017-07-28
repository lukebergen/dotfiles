function git_bit() {
  local blue="\033[38;5;4m"
  local red="\033[38;5;1m"
  local yellow="\033[38;5;11m"
  local green="\033[38;5;2m"
  local reset_color="\033[38;5;15m"

  if [ -d .git ]; then
    STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
    BRANCH=$(command git rev-parse --abbrev-ref HEAD)

    if [ $BRANCH = "HEAD" ]; then
      BRANCH=$(git rev-parse --short HEAD)
    fi

    if [[ -n $STATUS ]]; then
      echo "$blue($red$BRANCH $yellow✗$blue) $green$ $reset_color"
    else
      echo "$blue($red$BRANCH $green√$blue) $green$ $reset_color"
    fi
  else
    echo "$green$ $reset_color"
  fi

  echo $result
}

setopt promptsubst
PROMPT='%1~ $(git_bit)'
