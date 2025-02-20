#!/bin/bash

set -xe

if command -v aws; then
    echo "aws already installed"
else
    rm awscliv2.zip || true
    rm -r ./aws || true
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi
