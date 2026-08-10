#!/usr/bin/env zsh
# ~/.config/zsh/scripts/generate_completions.zsh
#
# Generates static shell completion files for CLI tools.
# Files are only (re)generated when missing or when --force is used.
#
# Usage:
#   generate_completions.zsh [--force] [--verbose] [--help] [tool...]
#
# Environment:
#   COMPLETIONS_DIR     Where to write files (default: $ZDOTDIR/completions)
#   FORCE_COMPLETIONS   Set to 1 for force mode (same as --force)

# emulate -L zsh: enforce native zsh semantics and scope options locally
# so sourcing this script won't pollute the parent shell's options.
emulate -L zsh
setopt errexit nounset pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

: "${COMPLETIONS_DIR:=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/completions}"

typeset -i force=0 verbose=0
typeset -a tools_filter=()
typeset -i _generated=0 _skipped=0 _failed=0

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_usage() {
  print "Usage: ${0:t} [options] [tool...]"
  print ""
  print "Options:"
  print "  -f, --force     Regenerate even if the completion file already exists"
  print "  -v, --verbose   Show detailed output, including stderr from tools"
  print "  -h, --help      Show this message and exit"
  print ""
  print "Arguments:"
  print "  tool...   Limit regeneration to specific tools (e.g. gh kubectl)"
  print ""
  print "Environment:"
  print "  COMPLETIONS_DIRDirectory to write files (default: ~/.zsh/completions)"
  print "  FORCE_COMPLETIONS  Set to 1 to enable force mode"print ""
  print "Examples:"
  print "  ${0:t}# generate any missing completions"
  print "  ${0:t} --force          # regenerate all completions"
  print "  ${0:t} gh kubectl       # regenerate only gh and kubectl"
}

_log() { print -- "[completions] $*"; }
_info() { if ((verbose)); then _log "$*"; fi; }
_warn() { print -u2 -- "[completions] WARNING: $*"; }

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while (($# > 0)); do
  case $1 in
  -f | --force) force=1 ;;
  -v | --verbose) verbose=1 ;;
  -h | --help)
    _usage
    exit 0
    ;;
  --)
    shift
    tools_filter+=("$@")
    break
    ;;
  -*)
    print -u2 "Unknown option: $1"
    _usage >&2
    exit 1
    ;;
  *) tools_filter+=("$1") ;;
  esac
  shift
done

# Honour the environment variable as an alternative to --force
[[ "${FORCE_COMPLETIONS:-0}" == 1 ]] && force=1

# ---------------------------------------------------------------------------
# Core generator
# ---------------------------------------------------------------------------
#
# generate_one <name> <output-filename> <cmd> [args...]
#
# Writes output atomically: generates to a temp file first, verifies it is
# non-empty, then renames it into place. Captures stderr separately so
# failures are always diagnosable.
# Always returns 0; failures are tallied in _failed.

generate_one() {
  local name=$1
  local dest="${COMPLETIONS_DIR}/${2}"
  shift 2
  local -a cmd=("$@")

  # Honour the tool filter when one was specified.
  if ((${#tools_filter} > 0)) && ((!${tools_filter[(Ie)$name]})); then
    return 0
  fi

  # Skip existing files unless --force was requested.
  if [[ -f $dest ]] && ((!force)); then
    _info "$name: up-to-date, skipping"
    ((++_skipped))
    return 0
  fi

  # Skip if the underlying binary is not installed.
  if ! command -v "${cmd[1]}" &>/dev/null; then
    _info "$name: '${cmd[1]}' not found, skipping"
    ((++_skipped))
    return 0
  fi

  # Prepare temp files.Use $$ to avoid collisions with parallel runs.
  local tmp="${dest}.tmp.$$"
  local err_file
  if ! err_file=$(mktemp); then
    _warn "$name: mktemp failed — skipping"
    ((++_failed))
    return 0
  fi

  # Run the generator.
  local exit_code=0
  "${cmd[@]}" >"$tmp" 2>"$err_file" || exit_code=$?

  if ((exit_code != 0)); then
    _warn "$name: '${cmd[*]}' exited with status $exit_code"
    if [[ -s $err_file ]]; then
      _warn "$name: stderr → $(<"$err_file")"
    fi
    rm -f -- "$tmp" "$err_file"
    ((++_failed))
    return 0
  fi

  # Guard against a command that exits 0 but writes nothing.
  if [[ ! -s $tmp ]]; then
    _warn "$name: command succeeded but produced no output"
    if ((verbose)) && [[ -s $err_file ]]; then
      _warn "$name: stderr → $(<"$err_file")"
    fi
    rm -f -- "$tmp" "$err_file"
    ((++_failed))
    return 0
  fi

  # Atomic rename — avoids leaving a partial file on a crash mid-write.
  mv -- "$tmp" "$dest"
  rm -f -- "$err_file"

  _log "$name: ✓  $dest"
  ((++_generated))
}

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

mkdir -p -- "$COMPLETIONS_DIR"

# ---------------------------------------------------------------------------
# Tool registry
# ---------------------------------------------------------------------------
# Format:  generate_one <name> <output-file> <command> [args...]
#

generate_one gh _gh gh completion -s zsh

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

_log "done — generated: ${_generated}  skipped: ${_skipped}  failed: ${_failed}"

if ((_failed > 0)); then
  exit 1
fi
