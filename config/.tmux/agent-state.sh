#!/usr/bin/env bash
# Script adapted from: https://github.com/craftzdog/tmux-claude-session-manager/
#
# Record an AI agent (Claude Code or Cursor) session's state on its tmux pane, for the picker.
# Wire this into agent hooks:
#
# "hooks": {
#   "Notification": [
#     {
#       "matcher": "permission_prompt",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "$HOME/.tmux/agent-state.sh waiting"
#         }
#       ]
#     }
#   ],
#   "PreToolUse": [
#     {
#       "matcher": "AskUserQuestion",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "$HOME/.tmux/agent-state.sh waiting"
#         }
#       ]
#     }
#   ],
#   "Stop": [
#     {
#       "matcher": "",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "$HOME/.tmux/agent-state.sh idle"
#         }
#       ]
#     }
#   ],
#   "UserPromptSubmit": [
#     {
#       "matcher": "",
#       "hooks": [
#         {
#           "type": "command",
#           "command": "$HOME/.tmux/agent-state.sh working"
#         }
#       ]
#     }
#   ]
# },
#
[ -z "$TMUX_PANE" ] && exit 0

tmux set-option -p -t "$TMUX_PANE" @agent_state "${1:-idle}"
tmux set-option -p -t "$TMUX_PANE" @agent_state_at "$(date +%s)"
exit 0
