#!/bin/bash
# Simple wrapper around pyinstaller

set -ex

# Generate a random key for encryption
random_key=$(pwgen -s 16 1)
pyinstaller_args="${@/--random-key/--key $random_key}"

COMPILE_STATIC="${COMPILE_STATIC:-false}"

if [ -f requirements.txt ]; then
    /usr/local/bin/pip3 install -r requirements.txt
elif [ -f setup.py ]; then
    /usr/local/bin/pip3 install .
fi

# Exclude pycrypto and PyInstaller from built packages
pyinstaller \
    -n dynamic \
    --exclude-module pycrypto \
    --exclude-module PyInstaller \
    ${pyinstaller_args}

if [ "$COMPILE_STATIC" = "true" ]; then
    staticx dist/dynamic dist/static
fi
