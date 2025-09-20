#----------------------------------------------
# FZF Configuration with fd, bat, eza, and fzf-git
#----------------------------------------------
# - fd: Fast file/directory search (replaces `find`)
# - bat: Syntax-highlighted file preview
# - eza: Colorful ls replacement with tree/dir display
# - fzf-git: Git-aware FZF integration (branches, commits, tags)
#----------------------------------------------

# Generic preview command:
# - If target is a directory: show as a tree (max depth: 2)
# - If target is a file: preview with syntax highlighting and line numbers
preview_command="
if [ -d {} ]; then
  eza --tree --level=2 --icons --color=always {} | head -200
else
  bat -n --color=always --paging=never {}
fi
"

#----------------------------------------------
# fzf's default file/directory population logic
#----------------------------------------------

# Candidate generation for all paths (fd ignores .git, includes hidden)
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Candidate generation for directories only
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

#----------------------------------------------
# Context-aware preview configuration
#----------------------------------------------
# Called with:
#   - $1: name of the triggering command (e.g., cd, ssh, export)
#   - $@: remaining fzf arguments
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)
      fzf --preview 'eza --tree --level=2 --icons --color=always {} | head -200' "$@" ;;
    export|unset)
      fzf --preview "printenv {}" "$@" ;;
    ssh)
      fzf --preview 'dig {}' "$@" ;;
    *)
      fzf --preview "$preview_command" "$@" ;;
  esac
}

#----------------------------------------------
# Global defaults for fzf
#----------------------------------------------

# Default search: files only
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'

# Ctrl-T: file picker
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview '$preview_command'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Alt-C: directory picker
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {} | head -200'"

#----------------------------------------------
# Git-related FZF helpers
#----------------------------------------------

# Adds Git-aware search commands (branches, commits, tags, etc.)
source ~/.config/fzf/fzf-git.sh
