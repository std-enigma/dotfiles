# --- Zoxide Shell Integration ---
# Initialize Zoxide for Zsh so its smarter directory-jumping commands and
# directory history are available in interactive shells.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
