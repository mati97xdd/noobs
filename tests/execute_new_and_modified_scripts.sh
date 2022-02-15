#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privileges!"
    exit 1
fi

latest_main_commit=$(git rev-parse "refs/remotes/origin/main")
current_commit=$(git rev-parse HEAD)

scripts_to_be_tested=$(git diff --no-color --name-only "$latest_main_commit" "$current_commit" | grep --color=never \\.sh$ | grep --color=never ^scripts\\/)

for item in $scripts_to_be_tested
do
    echo "Executing $item"
    if [[ `stat -c '%a' "$item"` != 7* ]]; then
        echo "Failed, $item lacks execution permission."
        exit 1
    fi
    sudo bash "$item"
    if [[ $? -ne 0 ]]; then
        echo "Failed executing $item"
        exit 1
    fi
done
