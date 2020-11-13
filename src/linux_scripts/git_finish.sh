#!/bin/sh

# This script contains a git wrapper function to make a final git commit to record
# all files generated after the last compiler call

MESSAGE=$(git status --porcelain --untracked-files=all)
git add -A >/dev/null
git commit -m "$MESSAGE" >/dev/null
