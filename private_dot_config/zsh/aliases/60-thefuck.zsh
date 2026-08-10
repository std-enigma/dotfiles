# --- The Fuck Aliases ---
# Initialize command-correction aliases only when The Fuck is installed.
if command -v thefuck >/dev/null 2>&1; then
  # Keep the default correction command and add two shorter alternatives.
  eval $(thefuck --alias)
  eval $(thefuck --alias tf)
  eval $(thefuck --alias fk)
fi
