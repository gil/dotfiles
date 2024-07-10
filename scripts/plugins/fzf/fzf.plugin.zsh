export FZF_DEFAULT_COMMAND='(
    fd --type f --strip-cwd-prefix --hidden --follow --exclude .git ||
    git ls-tree -r --name-only HEAD ||
    rg --files-with-matches --hidden --ignore .git -g "" ||
    ag --hidden --ignore .git -g "" ||
    ack --hidden --ignore .git -g "" ||
    find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//
) 2> /dev/null'

source $OH_MY_GIL_SH/scripts/themes/base16-themes/output/base16-fzf/bash/base16-gruvbox-dark-medium.config
