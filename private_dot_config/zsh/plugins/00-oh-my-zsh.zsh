# --- Oh My Zsh Location ---
# Check for system-wide install first, then fall back to XDG-compliant local path.
if [[ -d "/usr/share/oh-my-zsh" ]]; then
  export ZSH="/usr/share/oh-my-zsh"
else
  export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
fi

# --- Custom Resources Path ---
# Point to your custom configuration directory.
# Oh My Zsh will automatically search inside this path under 'plugins/' for custom hooks.
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# --- Prompt Management ---
# Disable Oh My Zsh themes because Starship is responsible for the prompt.
ZSH_THEME=""

# --- Plugin Selection ---
# Start with a small, intentional plugin list.
# Add more only when you know you need them.
plugins=(
  git
  sudo
  zsh-vi-mode
  zsh-256color
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# --- Framework Availability Check ---
# Verify that the main Oh My Zsh entry file exists and is readable before loading it.
# If it is missing, print an error to stderr and stop loading this module.
if [[ ! -r "$ZSH/oh-my-zsh.sh" ]]; then
  print -u2 -- "Oh My Zsh was not found at: $ZSH"
  return 1
fi

# --- Framework Initialization ---
# Load the Oh My Zsh framework.
source "$ZSH/oh-my-zsh.sh"
