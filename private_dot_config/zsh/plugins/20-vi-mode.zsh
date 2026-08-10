# --- Zsh Vi Mode Configuration ---

# Use sourcing mode when the zsh-vi-mode plugin is installed in the
# Oh My Zsh custom plugins directory.
if [[ -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]]; then
  ZVM_INIT_MODE="sourcing"
fi

# --- Keybinding Responsiveness ---

# Configure the time Zsh waits for a multi-key sequence to complete.
# A value of 15 equals 0.15 seconds and keeps Esc responsive without making
# normal-mode commands such as `dd`, `ciw`, or `gg` difficult to enter.
initialize_keytimeout() {
  KEYTIMEOUT=15
}

# Zsh Vi Mode configures keymaps lazily and may replace its KEYTIMEOUT value
# during initialization. Apply the preferred timeout immediately afterward.
if ((${+functions[zvm_init]})); then
  zvm_after_init_commands+=(initialize_keytimeout)
else
  initialize_keytimeout
fi
