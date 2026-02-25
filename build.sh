#!/bin/bash

SHELL_PATH=$(dirname $(readlink -f "$0"))

cd "$SHELL_PATH"

source "/home/shell/[common]/environment_update.sh"

export ENDPOINT="/admin"

#npm install

npm run build
