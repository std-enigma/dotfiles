# ── preview helper ────────────────────────────────────────────────────────────
_fzf_preview_cmd='
  if [ -d {} ]; then
    eza --tree --level=2 --icons --color=always {} | head -200
  else
    bat -n --color=always --paging=never {}
  fi
'

# ── core ──────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git --strip-cwd-prefix'

export FZF_DEFAULT_OPTS="
  --height=60% --layout=reverse --border
  --preview '$_fzf_preview_cmd'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# ── Ctrl-T: files & dirs ──────────────────────────────────────────────────────
# FZF_CTRL_T_COMMAND intentionally omitted — inherits FZF_DEFAULT_COMMAND

export FZF_CTRL_T_OPTS="
  --preview '$_fzf_preview_cmd'
"

# ── Alt-C: dirs only ──────────────────────────────────────────────────────────
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --strip-cwd-prefix'

export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --icons --color=always {}'
"

# ── completion path/dir generators ───────────────────────────────────────────
_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

# ── context-aware comprun ─────────────────────────────────────────────────────
_fzf_comprun() {
  local cmd=$1
  shift
  case "$cmd" in
  cd) fzf --preview 'eza --tree --level=2 --icons --color=always {}' "$@" ;;
  export | unset) fzf --preview 'printenv {}' "$@" ;;
  ssh) fzf --preview 'grep -A5 "^Host {}" ~/.ssh/config 2>/dev/null || echo "no config entry"' "$@" ;;
  *) fzf --preview "$_fzf_preview_cmd" "$@" ;;
  esac
}
