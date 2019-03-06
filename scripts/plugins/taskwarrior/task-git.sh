#!/bin/bash

TASKBIN="/usr/local/bin/task"
TASKDIR="$HOME/.task"
SYNC_INTERVAL=600 # 5 minutes

cd $TASKDIR

# Update git repo if more than X seconds since last commmand
CURRENT_TIME=$(date +%s)

if [ -f $TASKDIR/.last_git_sync ]; then
    LAST_UPDATE_TIME=$(cat $TASKDIR/.last_git_sync)
fi

if [ -z "$LAST_UPDATE_TIME" ] || [ $(($CURRENT_TIME - $LAST_UPDATE_TIME)) -gt $SYNC_INTERVAL ]; then
    echo "⏳ Updating tasks..."
    git -c rebase.autoStash=true pull --rebase
fi

# Couldn't pull? Stop now so I can fix manually
if [ $? -ne 0 ]; then
    exit $?
fi

# Update sync time
echo $(date +%s) > $TASKDIR/.last_git_sync

# Run original command
"$TASKBIN" "$@"
EXITCODE=$?

# Any change to the repo? Commit now
if [ $(git status --short | wc -c) -ne 0 ]; then
    # Silently call taskwarrior again to update other files, like moving from pending.data to completed.data
    "$TASKBIN" count &> /dev/null

    git add .
    git commit --quiet -m "Automatic update of tasks from [$USER@$(hostname)] at [$(date)]"
fi

# Push any new commits
if [ $(git log @{u}.. --oneline | wc -c) -ne 0 ]; then
    echo

    echo "⏳ Pushing task changes..."
    git push &> $TASKDIR/.last_git_push_log

    if [ $? -ne 0 ]; then
        echo "⚠️  Couldn't push! Pulling and trying again...."
        git -c rebase.autoStash=true pull --quiet --rebase && git push &> $TASKDIR/.last_git_push_log
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Git data in sync!"
    else
        echo "⛔️ Couldn't push task changes! Check: $TASKDIR/.last_git_push_log"
    fi
fi

exit $EXITCODE
