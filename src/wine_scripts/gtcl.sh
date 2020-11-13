#!/bin/bash

# This script is a msvc cl wrapper that uses git to record every file generated
# by a compiler using git.

. ${GT_ORIGIN_MSVC_WRAPPERS}/msvcenv.sh
${GT_ORIGIN_MSVC_WRAPPERS}/wine-msvc.sh $BINDIR/cl.exe "${@:3}"
echo $? > /tmp/${1}-ret

MESSAGE=$(git status --porcelain --untracked-files=all)
git add -A >/dev/null
git commit -m "$MESSAGE" >/dev/null

touch /tmp/${1}-done
