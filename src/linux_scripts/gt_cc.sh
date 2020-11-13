#!/bin/bash

# This script is a compiler wrapper that uses git to record every file generated
# by a compiler using git.

$GT_ORIGIN_CC "$@"
MESSAGE=$(git status --porcelain --untracked-files=all)
git add -A >/dev/null
git commit -m "$MESSAGE" >/dev/null
