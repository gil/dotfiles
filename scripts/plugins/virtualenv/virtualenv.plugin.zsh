function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

# disables prompt mangling in virtual_env/bin/activate
#export VIRTUAL_ENV_DISABLE_PROMPT=1

# aliases to make it easier
alias vea="deactivate &> /dev/null ; source ./venv/bin/activate"
alias ved="deactivate"
alias vec="python3 -m venv venv"
