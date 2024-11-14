alias ta='tmux attach || tmux'

function tmux-dev() {
  tmux rename-session "$(basename "$PWD")"
  tmux new-window -c "$PWD"
  tmux select-window -t 0
  nvim
}
