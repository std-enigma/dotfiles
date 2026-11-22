#!/bin/bash
set -euo pipefail

if command -v tmux >/dev/null 2>&1; then
    CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
    TPM_DIR="$CONFIG_DIR/tmux/plugins/tpm"
    
    if [ ! -d "$TPM_DIR" ]; then
        echo "Installing Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    else
        echo "TPM is already installed. Skipping."
    fi
else
    echo "tmux is not installed, skipping TPM installation."
fi
