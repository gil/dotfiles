alias ta='tmux attach'

function tmux-dev() {
    tmux rename-window "$(basename "$PWD")"
    tmux split-window -h
    tmux split-window
    tmux resize-pane -t 1 -x $(expr $(tmux display -p '#{window_width}') \* 35 \/ 100)
    tmux resize-pane -t 2 -y $(expr $(tmux display -p '#{window_height}') \* 15 \/ 100)
    tmux select-pane -t 0
}
