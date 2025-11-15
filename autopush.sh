#!/bin/bash
# Auto-push /opt/OPFOR-RedOps-Tactics repo to GitHub
# Author: haunter
# cron job:
# */30 * * * * /opt/OPFOR-RedOps-Tactics/autopush.sh >> /opt/OPFOR-RedOps-Tactics/autopush.log 2>&1

set -e  # Exit immediately if any command fails

cd /opt/OPFOR-RedOps-Tactics || exit 1

# Use SSH key for Git (edit this path if different)
export GIT_SSH_COMMAND="ssh -i /home/haunter/.ssh/github-ops"

echo "[$(date)] Starting auto-push..."

# Pull first to stay synced with remote
git fetch origin main
git rebase origin/main || git merge origin/main || echo "No remote changes to merge."

# Stage everything (including deletions)
git add -A

# Commit if there are staged changes
if ! git diff --cached --quiet; then
    COMMIT_MSG="Auto sync: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$(date)] Changes detected — committing..."
    git commit -m "$COMMIT_MSG"
    echo "[$(date)] Pushing to GitHub..."
    git push origin main
    echo "[$(date)] Push complete."
else
    echo "[$(date)] No changes detected — nothing to commit."
fi

