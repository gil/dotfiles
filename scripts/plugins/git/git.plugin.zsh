# Query/use custom command for `git`.
zstyle -s ":vcs_info:git:*:-all-" "command" _omz_git_git_cmd
: ${_omz_git_git_cmd:=git}

#
# Functions
#

# The current branch name
# Usage example: git pull origin $(current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function current_branch() {
  local ref
  ref=$($_omz_git_git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$($_omz_git_git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}
# The list of remotes
function current_repository() {
  if ! $_omz_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omz_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

#
# Aliases
# (sorted alphabetically)
#

alias ga='git add'
alias gai='git add -i'
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit -v'
alias gcz='npx git-cz --disable-emoji --scope'
alias gco='git checkout'
alias gcm="git checkout \$(git branch -rl '*/HEAD' | grep -o '[^/]\+$')"
alias gfa='git fetch --all --prune'
alias gl='git pull'
#alias glr='git -c rebase.autoStash=true pull --rebase'
alias glr='git -c rebase.autoStash=true pull --rebase $(git rev-parse --abbrev-ref @{upstream} | sed "s/\// /")'
#alias glog='git log --oneline --decorate --color --graph'
alias glog='git log --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%C(auto,yellow)%h%C(auto,blue)%>(17,trunc)%ad %C(auto,green)%<(20,trunc)%ae %C(auto,reset)%s%C(auto,red)% gD% D"'
alias gglog='git log --graph --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%C(auto,yellow)%h%C(auto,blue)%>(17,trunc)%ad %C(auto,green)%<(20,trunc)%ae %C(auto,reset)%s%C(auto,red)% gD% D"'
#alias gilog='git log --oneline --decorate --color --graph --author="$(git config user.name)"'
alias gilog='git log --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%C(auto,yellow)%h%C(auto,blue)%>(17,trunc)%ad %C(auto,reset)%s%C(auto,red)% gD% D" --author="$(git config user.name)"'
alias ggilog='git log --graph --date=format:"%Y-%m-%d %H:%M" --pretty=format:"%C(auto,yellow)%h%C(auto,blue)%>(17,trunc)%ad %C(auto,reset)%s%C(auto,red)% gD% D" --author="$(git config user.name)"'
alias glola="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias gp='git push'
alias gpf='git push --force-with-lease'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias gst='git status --short --branch'
alias gbold='git for-each-ref --sort=committerdate --format="%(refname:short) * %(authorname) * %(committerdate:relative)" refs/remotes/ | column -t -s "*"'
alias gmt='git mergetool --no-prompt'
alias gd='git diff --ignore-all-space --color-moved'
alias gds='gd --staged'
alias gff='git ls-files | grep -i'
alias gme='git merge --no-ff'

alias findorig="find . -name '*.orig'"
alias deleteorig="find . -name '*.orig' -delete"

# alias g='git'

# alias gaa='git add --all'
# alias gapa='git add --patch'

# alias gba='git branch -a'
# alias gbda='git branch --merged | command grep -vE "^(\*|\s*master\s*$)" | command xargs -n 1 git branch -d'
# alias gbl='git blame -b -w'
# alias gbnm='git branch --no-merged'
# alias gbr='git branch --remote'
# alias gbs='git bisect'
# alias gbsb='git bisect bad'
# alias gbsg='git bisect good'
# alias gbsr='git bisect reset'
# alias gbss='git bisect start'

# alias gc!='git commit -v --amend'
# alias gca='git commit -v -a'
# alias gca!='git commit -v -a --amend'
# alias gcan!='git commit -v -a -s --no-edit --amend'
# alias gcb='git checkout -b'
# alias gcf='git config --list'
# alias gcl='git clone --recursive'
# alias gclean='git reset --hard && git clean -dfx'
# alias gcm='git checkout master'
# alias gcmsg='git commit -m'
# alias gcount='git shortlog -sn'
# compdef gcount=git
# alias gcp='git cherry-pick'
# alias gcs='git commit -S'

# alias gd='git diff'
# alias gdca='git diff --cached'
# alias gdt='git diff-tree --no-commit-id --name-only -r'
# gdv() { git diff -w "$@" | view - }
# compdef _git gdv=git-diff
# alias gdw='git diff --word-diff'

# alias gf='git fetch'
# function gfg() { git ls-files | grep $@ }
# compdef gfg=grep
# alias gfo='git fetch origin'

# alias gg='git gui citool'
# alias gga='git gui citool --amend'
# ggf() {
# [[ "$#" != 1 ]] && local b="$(current_branch)"
# git push --force origin "${b:=$1}"
# }
# compdef _git ggf=git-checkout
# ggl() {
# if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
# git pull origin "${*}"
# else
# [[ "$#" == 0 ]] && local b="$(current_branch)"
# git pull origin "${b:=$1}"
# fi
# }
# compdef _git ggl=git-checkout
# alias ggpull='git pull origin $(current_branch)'
# compdef _git ggpull=git-checkout
# ggp() {
# if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
# git push origin "${*}"
# else
# [[ "$#" == 0 ]] && local b="$(current_branch)"
# git push origin "${b:=$1}"
# fi
# }
# compdef _git ggp=git-checkout
# alias ggpush='git push origin $(current_branch)'
# compdef _git ggpush=git-checkout
# ggpnp() {
# if [[ "$#" == 0 ]]; then
# ggl && ggp
# else
# ggl "${*}" && ggp "${*}"
# fi
# }
# compdef _git ggpnp=git-checkout
# alias ggsup='git branch --set-upstream-to=origin/$(current_branch)'
# ggu() {
# [[ "$#" != 1 ]] && local b="$(current_branch)"
# git pull --rebase origin "${b:=$1}"
# }
# compdef _git ggu=git-checkout
# alias ggpur='ggu'
# compdef _git ggpur=git-checkout

# alias gignore='git update-index --assume-unchanged'
# alias gignored='git ls-files -v | grep "^[[:lower:]]"'
# alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
# compdef git-svn-dcommit-push=git

# alias gk='\gitk --all --branches'
# compdef _git gk='gitk'
# alias gke='\gitk --all $(git log -g --pretty=format:%h)'
# compdef _git gke='gitk'

# alias glg='git log --stat --color'
# alias glgp='git log --stat --color -p'
# alias glgg='git log --graph --color'
# alias glgga='git log --graph --decorate --all'
# alias glgm='git log --graph --max-count=10'
# alias glo='git log --oneline --decorate --color'
# alias glol="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# alias glp="_git_log_prettily"
# compdef _git glp=git-log

# alias gm='git merge'
# alias gmom='git merge origin/master'
# alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
# alias gmum='git merge upstream/master'

# alias gpd='git push --dry-run'
# alias gpoat='git push origin --all && git push origin --tags'
# compdef _git gpoat=git-push
# alias gpu='git push upstream'
# alias gpv='git push -v'

# alias gr='git remote'
# alias gra='git remote add'
# alias grb='git rebase'
# alias grbm='git rebase master'
# alias grbs='git rebase --skip'
# alias grh='git reset HEAD'
# alias grhh='git reset HEAD --hard'
# alias grmv='git remote rename'
# alias grrm='git remote remove'
# alias grset='git remote set-url'
# alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
# alias gru='git reset --'
# alias grup='git remote update'
# alias grv='git remote -v'

# alias gsb='git status -sb'
# alias gsd='git svn dcommit'
# alias gsi='git submodule init'
# alias gsps='git show --pretty=short --show-signature'
# alias gsr='git svn rebase'
# alias gss='git status -s'
# alias gst='git status'
# alias gsta='git stash'
# alias gstaa='git stash apply'
# alias gstd='git stash drop'
# alias gstl='git stash list'
# alias gstp='git stash pop'
# alias gsts='git stash show --text'
# alias gsu='git submodule update'

# alias gts='git tag -s'

# alias gunignore='git update-index --no-assume-unchanged'
# alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
# alias gup='git pull --rebase'
# alias gupv='git pull --rebase -v'

# alias gvt='git verify-tag'

# alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
# alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--"'
