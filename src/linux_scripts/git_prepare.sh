#!/bin/sh

# This script contains a git wrapper function to initialize a git-managed
# file system for ground truth generation.

find . -name ".gitignore" -prune -exec rm -rf {} \; >/dev/null
find . -name ".git" -prune -exec rm -rf {} \; >/dev/null
git init >/dev/null
git add -A >/dev/null
git commit -m "Before Build" >/dev/null
