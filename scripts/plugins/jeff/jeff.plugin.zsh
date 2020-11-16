jeff() {
  if ! [ -n "$TMUX" ]; then
    tmux attach -t jeff || tmux new-session -s jeff -n "Jeff"
  else
    fc -p $HOME/.jeff_history
    selected=($(
      fc -rl 1 |
        perl -ne 'print if !$seen{(/^\s*[0-9]+\s+(.*)/, $1)}++' |
        grep -v '  \(jeff\|exit\)$' |
        FZF_DEFAULT_OPTS="-n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort --query=${(qqq)LBUFFER} +m" fzf
    ))
    local ret=$?
    if [ -n "$selected" ]; then
      jeff_cmd=$selected[1] # 1 = history index, 2+ = command
      if [ -n "$jeff_cmd" ]; then
        fc -e - $jeff_cmd && __hide_iterm2_hotkey_window
      fi
    fi
  fi
}

__hide_iterm2_hotkey_window() {
  osascript -e 'tell application "iTerm2"
    tell current window
      hide hotkey window
    end tell
  end tell'
}
