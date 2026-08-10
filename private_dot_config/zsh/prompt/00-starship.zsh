# --- Starship Prompt Initialization ---
# Starship is a fast, cross-shell prompt written in Rust.
# We initialize it here after Oh My Zsh to ensure it has final control
# over the prompt (PS1).

if command -v starship >/dev/null 2>&1; then
  # Initialize starship. 
  # Note: This 'eval' is generally fast enough because Starship is highly optimized.
  eval "$(starship init zsh)"
else
  # Fallback prompt if starship is missing
  PROMPT='%n@%m %1~ %# '
fi
