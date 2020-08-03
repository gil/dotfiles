export FZF_DEFAULT_COMMAND='(
    git ls-tree -r --name-only HEAD ||
    ag --hidden --ignore .git -g "" ||
    ack --hidden --ignore .git -g "" ||
    find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//
) 2> /dev/null'

source $OH_MY_GIL_SH/scripts/themes/base16-themes/output/base16-fzf/bash/base16-gruvbox-dark-medium.config
