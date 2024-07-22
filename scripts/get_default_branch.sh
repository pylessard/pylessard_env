#!/bin/bash

flag_force=0

while getopts "f" flag; do
case ${flag} in
 f) flag_force=1;;
esac
done

repo_hash=$(echo  -n $(git remote get-url origin) | sha256sum | head -c 40)
storage_dir="/tmp/pylessard_env/"
mkdir -p "$storage_dir"
cache_file="$storage_dir/$repo_hash"

if [ -f "$cache_file" -a $flag_force -eq 0 ]; then
    cat "$cache_file"
else
    default_branch=$(git remote show origin | sed -n "/HEAD branch/s/.*: //p")
    echo -n $default_branch | tee $cache_file
fi