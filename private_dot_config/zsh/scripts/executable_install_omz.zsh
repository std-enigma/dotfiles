#!/usr/bin/env zsh
# ~/.config/zsh/scripts/install_oh_my_zsh.zsh
#
# Bootstraps Oh My Zsh for a modular XDG-based Zsh setup.
# Prefers the Arch system package; falls back to a user-local clone.
# Safe to run multiple times. Does NOT modify ~/.zshrc.
#
# Usage:
#   install_oh_my_zsh.zsh [--update]
#
# Environment:
#   XDG_DATA_HOME   Base for user data (default: ~/.local/share)

emulate -L zsh
setopt errexit nounset pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

typeset -r OMZ_SYSTEM=/usr/share/oh-my-zsh
typeset -r OMZ_USER="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
typeset -r OMZ_REPO=https://github.com/ohmyzsh/ohmyzsh.git

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_info() { print -- "[omz] $*"; }
_warn() { print -u2 -- "[omz] WARNING: $*"; }
_error() {
  print -u2 -- "[omz] ERROR: $*"
  return 1
}

# Validate that oh-my-zsh.sh is present under a given root.
_validate() {
  local root=$1
  [[ -f ${root}/oh-my-zsh.sh ]] || _error "oh-my-zsh.sh not found under ${root}"
}

# ---------------------------------------------------------------------------
# Update function (optional, not called during bootstrap)
# ---------------------------------------------------------------------------

omz_update() {
  local root=$1
  if [[ ! -d ${root}/.git ]]; then
    _warn "Cannot update: ${root} is not a git repository (system package?)"
    return 0
  fi
  _info "Updating Oh My Zsh at ${root} ..."
  git -C "$root" pull --ff-only
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

typeset -i do_update=0
for arg in "$@"; do
  case $arg in
  --update) do_update=1 ;;
  *) _error "Unknown argument: ${arg}" ;;
  esac
done

# ---------------------------------------------------------------------------
# Bootstrap
# ---------------------------------------------------------------------------

# 1. Prefer the Arch system package.
if [[ -d $OMZ_SYSTEM ]]; then
  _info "Using system package: ${OMZ_SYSTEM}"
  _validate "$OMZ_SYSTEM"
  ((do_update)) && omz_update "$OMZ_SYSTEM"
  exit 0
fi

# 2. Check for an existing user-local install.
if [[ -d $OMZ_USER ]]; then
  _info "User install already exists: ${OMZ_USER}"
  _validate "$OMZ_USER"
  ((do_update)) && omz_update "$OMZ_USER"
  exit 0
fi

# 3. Clone into the XDG user data directory.
if ! command -v git &>/dev/null; then
  _error "git is required but not found in PATH"
fi

_info "Cloning Oh My Zsh into ${OMZ_USER} ..."
mkdir -p -- "${OMZ_USER:h}"
git clone --depth=1 -- "$OMZ_REPO" "$OMZ_USER"

# 4. Validate the installation.
_validate "$OMZ_USER"
_info "Installation complete: ${OMZ_USER}"
