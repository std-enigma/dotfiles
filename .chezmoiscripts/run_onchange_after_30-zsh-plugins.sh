#!/bin/bash
# Bootstraps Oh My Zsh and the custom plugins used by dot_zshrc.
# install_omz.zsh prefers the system package (/usr/share/oh-my-zsh, provided by
# the oh-my-zsh-git AUR package) and only clones when it is missing.
# Both helpers are idempotent and run as the user.
set -euo pipefail

zsh_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

if ! command -v zsh >/dev/null 2>&1; then
  echo "!! zsh not installed; skipping Oh My Zsh setup"
  exit 0
fi

if [ ! -x "$zsh_dir/scripts/install_omz.zsh" ]; then
  echo "!! $zsh_dir/scripts/install_omz.zsh not found; skipping"
  exit 0
fi

export ZDOTDIR="$zsh_dir"
zsh "$zsh_dir/scripts/install_omz.zsh"
zsh "$zsh_dir/scripts/install_plugins.zsh"
