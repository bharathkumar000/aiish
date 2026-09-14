#!/bin/bash
# ==============================================================================
# Script: push_one_daily.sh
# Purpose: Finds modified tracked files (or new untracked files), stages and
#          commits exactly one file with "Update <file>", and pushes to remote.
# ==============================================================================

set -e

# Ensure git is in PATH for macOS cron
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

REPO_DIR="/Users/bharathkumara/Desktop/AIISH"
cd "$REPO_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 1. Find modified tracked files using git diff --name-only
FILE=$(git diff --name-only | head -n 1)

# Fallback: check untracked files if no tracked files are modified
if [ -z "$FILE" ]; then
    FILE=$(git ls-files --others --exclude-standard | head -n 1)
fi

# 5. If there are no modified files, do nothing
if [ -z "$FILE" ]; then
    echo "[$TIMESTAMP] No modified or untracked files found. Nothing to commit."
    exit 0
fi

# 2 & 3. Stage only that single file, commit, and push
echo "[$TIMESTAMP] Processing single file: $FILE"
git add "$FILE"
git commit -m "Update $FILE"
git push origin main

echo "[$TIMESTAMP] Successfully committed and pushed: $FILE"
