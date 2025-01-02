#!/usr/bin/env bash
set -eu

# this was something copy/pasted from online. I think it might be the way to go though. Basically...
# 1. take stdin and write it to a tmp file
# 2. open nvim with any desired settings
# 3. open a terminal window (which can handle the escape sequences that kitty will send over)
# 4. in the terminal window (in vim) cat the tmp file
# 5. any post-processing stuff like <C-\><C-n> to get back to normal mode and such

if [ "$#" -eq 3 ]; then
    INPUT_LINE_NUMBER=${1:-0}
    CURSOR_LINE=${2:-1}
    CURSOR_COLUMN=${3:-1}
    AUTOCMD_TERMCLOSE_CMD="call cursor(max([0,${INPUT_LINE_NUMBER}-1])+${CURSOR_LINE}, ${CURSOR_COLUMN})"
else
    AUTOCMD_TERMCLOSE_CMD="normal G"
fi

exec nvim 63<&0 0</dev/null \
    -u NONE \
    -c "map <silent> q :qa!<CR>" \
    -c "set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus" \
    -c "autocmd TermEnter * stopinsert" \
    -c "autocmd TermClose * ${AUTOCMD_TERMCLOSE_CMD}" \
    -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b'']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b'']2;"'
