#!/bin/bash

# This script aims to solve the problem that old clang (for example 3.8.0) cannot
# compile programs using --save-temps and -g flags at the same time under x86.

AsmArg=()
ExeArg=()
NextObj=false
HasMinusC=false
for i in "$@"
do
  if [ "$i" == "-c" ]; then
    HasMinusC=true
  fi
  if [ "$i" == "-save-temps" ]; then
    continue
  fi
  if [ "$i" == "--save-temps" ]; then
    continue
  fi
  ExeArg+=("$i")
  if [ "$NextObj" == true ]; then
    NextObj=false
    continue
  fi
  if [ "$i" == "-o" ]; then
    NextObj=true
    continue
  fi
  AsmArg+=("$i")
done
if [ "$HasMinusC" == true ]; then
  clang++ ${ExeArg[@]} && clang++ -S ${AsmArg[@]} >/dev/null 2>&1
else
  clang++ ${ExeArg[@]} && clang++ -S ${AsmArg[@]} >/dev/null 2>&1 && clang++ -c ${AsmArg[@]} > /dev/null 2>&1
fi
