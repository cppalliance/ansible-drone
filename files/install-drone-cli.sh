#!/bin/bash

set -xe

if [ ! -f /usr/local/bin/drone ]; then
    rm drone || true
    curl -L https://github.com/harness/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
    sudo install -t /usr/local/bin drone
fi
