if [ -f ~/.nvm/nvm.sh ]; then
    ##
    # This will try to lazy load NVM only when needed, since initializing it could be slow
    ###

    declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)

    NODE_GLOBALS+=("node")
    NODE_GLOBALS+=("nvm")
    NODE_GLOBALS+=("yarn")

    load_nvm () {
        export NVM_DIR=~/.nvm
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    }

    for cmd in "${NODE_GLOBALS[@]}"; do
        eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
    done
fi
