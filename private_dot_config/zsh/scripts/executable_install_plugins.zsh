#!/usr/bin/env zsh
# install_zsh_plugins.zsh
#
# Installs or updates custom Oh My Zsh plugins into:
#   ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
#
# Idempotent, safe to re-run, and safe to source. Does NOT modify .zshrc.
#
# Usage:
#   install_zsh_plugins.zsh [options] [plugin-name...]
#
# Options:
#   -n, --dry-run    Show what would happen without doing it
#   -u, --no-update  Install missing plugins only; skip updating existing ones
#   -v, --verbose    Show full git output
#   -h, --help       Show help and exit

# emulate -L zsh: native zsh semantics, options scoped locally so sourcing
# this script never leaks errexit/nounset into the parent shell.
emulate -L zsh
setopt errexit nounset pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
# NOTE: deliberately not `readonly` — readonly vars error out if this file
# is sourced twice in the same shell session.

PLUGINS_DIR="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"

# Registry format:  "github-user/repo[@ref]"
#   The optional @ref pins a branch or tag (default: the remote's HEAD).
#   Directory name is derived from the repo name.
typeset -a PLUGINS=(
  "jeffreytse/zsh-vi-mode"
  "chrissicool/zsh-256color"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
)

typeset -i dry_run=0 no_update=0 verbose=0
typeset -a name_filter=()
typeset -i _installed=0 _updated=0 _skipped=0 _failed=0

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_usage() {
  print "Usage: ${0:t} [options] [plugin-name...]"
  print ""
  print "Options:"
  print "  -n, --dry-run    Show what would happen without making changes"
  print "  -u, --no-update  Only install missing plugins; don't update existing"
  print "  -v, --verbose    Show full git output"
  print "  -h, --help       Show this message and exit"
  print ""
  print "Arguments:"
  print "  plugin-name...   Limit to specific plugins (e.g. zsh-autosuggestions)"
  print ""
  print "Environment:"
  print "  ZSH_CUSTOM       Oh My Zsh custom dir (default: ~/.oh-my-zsh/custom)"
  print ""
  print "Examples:"
  print "  ${0:t}                        # install missing, update existing"
  print "  ${0:t} --no-update            # install missing only"
  print "  ${0:t} zsh-autosuggestions    # process just one plugin"
}

_log() { print -- "[plugins] $*"; }
_info() { if ((verbose)); then _log "$*"; fi; }
_warn() { print -u2 -- "[plugins] WARNING: $*"; }

# Run a git command, capturing stderr so failures are always diagnosable.
# Prints stderr only on failure (or always, in verbose mode).
_git() {
  local err_file exit_code=0
  if ! err_file=$(mktemp); then
    _warn "mktemp failed"
    return 1
  fi

  if ((verbose)); then
    git "$@" 2>&1 || exit_code=$?
  else
    git "$@" >/dev/null 2>"$err_file" || exit_code=$?
  fi

  if ((exit_code != 0)) && [[ -s $err_file ]]; then
    _warn "git $1 failed → $(<"$err_file")"
  fi

  rm -f -- "$err_file"
  return $exit_code
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while (($# > 0)); do
  case $1 in
  -n | --dry-run) dry_run=1 ;;
  -u | --no-update) no_update=1 ;;
  -v | --verbose) verbose=1 ;;
  -h | --help)
    _usage
    exit 0
    ;;
  --)
    shift
    name_filter+=("$@")
    break
    ;;
  -*)
    print -u2 "Unknown option: $1"
    _usage >&2
    exit 1
    ;;
  *) name_filter+=("$1") ;;
  esac
  shift
done

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------

if ! command -v git &>/dev/null; then
  print -u2 "ERROR: 'git' is not installed or not in PATH."
  exit 1
fi

if ((dry_run)); then
  _log "dry-run mode — no changes will be made"
fi

if [[ ! -d $PLUGINS_DIR ]]; then
  _log "creating plugins directory: $PLUGINS_DIR"
  ((dry_run)) || mkdir -p -- "$PLUGINS_DIR"
fi

# ---------------------------------------------------------------------------
# Core: install or update one plugin
# ---------------------------------------------------------------------------
# Always returns 0 — one broken plugin (network error, deleted repo, rewritten
# history) must not abort the rest of the run. Failures are tallied instead.

install_or_update_plugin() {
  local entry=$1
  local repo="${entry%%@*}" # user/name
  local ref=""
  [[ $entry == *@* ]] && ref="${entry##*@}"
  local name="${repo##*/}" # name
  local dest="${PLUGINS_DIR}/${name}"
  local url="https://github.com/${repo}.git"

  # Honour the name filter when one was given.
  if ((${#name_filter} > 0)) && ((!${name_filter[(Ie)$name]})); then
    return 0
  fi

  # -- Case 1: directory exists but isn't a git repo -----------------------
  # Don't touch it — it may be a manually-installed or symlinked plugin.
  if [[ -d $dest && ! -d $dest/.git ]]; then
    _warn "$name: $dest exists but is not a git clone — leaving it alone"
    ((++_skipped))
    return 0
  fi

  # -- Case 2: already cloned ----------------------------------------------
  if [[ -d $dest/.git ]]; then
    # Sanity check: does the remote still point at the repo we expect?
    local actual_url
    actual_url=$(git -C "$dest" remote get-url origin 2>/dev/null) || actual_url=""
    if [[ -n $actual_url && ${actual_url%.git} != ${url%.git} ]]; then
      _warn "$name: origin is '$actual_url', expected '$url' — skipping"
      ((++_skipped))
      return 0
    fi

    if ((no_update)); then
      _info "$name: already installed, updates disabled"
      ((++_skipped))
      return 0
    fi

    _log "$name: updating..."
    if ((dry_run)); then
      _log "$name: [dry-run] would run: git -C $dest pull --ff-only"
      return 0
    fi

    # Shallow clones can occasionally fail a plain pull if upstream
    # rewrote history; fetch + hard reset to the remote ref is robust.
    if _git -C "$dest" fetch --depth 1 origin ${ref:+"$ref"} &&
      _git -C "$dest" reset --hard FETCH_HEAD; then
      _log "$name: ✓ up to date"
      ((++_updated))
    else
      _warn "$name: update failed"
      ((++_failed))
    fi
    return 0
  fi

  # -- Case 3: fresh install -------------------------------------------------
  _log "$name: installing → $dest"
  if ((dry_run)); then
    _log "$name: [dry-run] would run: git clone --depth 1 $url"
    return 0
  fi

  # Clone into a temp dir first, then rename into place. An interrupted
  # clone therefore never leaves a broken half-populated plugin directory.
  local tmp="${dest}.tmp.$$"
  if _git clone --depth 1 ${ref:+--branch "$ref"} -- "$url" "$tmp"; then
    mv -- "$tmp" "$dest"
    _log "$name: ✓ installed"
    ((++_installed))
  else
    rm -rf -- "$tmp"
    _warn "$name: clone failed"
    ((++_failed))
  fi
}

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

for plugin in "${PLUGINS[@]}"; do
  install_or_update_plugin "$plugin"
done

# ---------------------------------------------------------------------------
# Summary + reminder
# ---------------------------------------------------------------------------

_log "done — installed: ${_installed}  updated: ${_updated}  skipped: ${_skipped}  failed: ${_failed}"

if ((_installed > 0)); then
  print ""
  print "Add these to the plugins=(...) array in your ~/.zshrc if not already present:"
  print ""
  print "    plugins=("
  print "      git"
  print "      sudo"
  print "      zsh-vi-mode"
  print "      zsh-256color"
  print "      zsh-autosuggestions"
  print "      zsh-syntax-highlighting   # must be last"
  print "    )"
  print ""
fi

if ((_failed > 0)); then
  exit 1
fi
