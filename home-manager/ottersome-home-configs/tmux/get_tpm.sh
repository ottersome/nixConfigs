#!/bin/sh
HOME_DEST=$1

TPM_DIR="$1/.tmux/plugins/tpm"
TPM_REPO="https://github.com/tmux-plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    git clone "$TPM_REPO" "$TPM_DIR"
fi
