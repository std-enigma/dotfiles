# --- FzF Shell Integration ---
# Initialize fzf after Zsh Vi Mode finishes configuring its keymaps so fzf's
# completion and Git bindings are not overwritten.
initialize_fzf() {
  local fzf_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fzf"

  if ! command -v fzf >/dev/null 2>&1; then
    return
  fi

  # Load candidate generators and preview settings before fzf initialization.
  [[ -r "$fzf_config_dir/config.sh" ]] &&
    source "$fzf_config_dir/config.sh"

  # Load the theme after base settings so its color options take precedence.
  [[ -r "$fzf_config_dir/theme.sh" ]] &&
    source "$fzf_config_dir/theme.sh"

  # Enable fzf's standard key bindings and fuzzy completion.
  source <(fzf --zsh)

  # Add Git-aware pickers when Git and the integration script are available.
  if command -v git >/dev/null 2>&1 &&
    [[ -r "$fzf_config_dir/fzf-git.sh" ]]; then
    source "$fzf_config_dir/fzf-git.sh"
  fi
}

# Zsh Vi Mode initializes its keymaps lazily and can overwrite bindings from
# plugins loaded earlier. Run fzf initialization immediately afterward.
if ((${+functions[zvm_init]})); then
  zvm_after_init_commands+=(initialize_fzf)
else
  initialize_fzf
fi
