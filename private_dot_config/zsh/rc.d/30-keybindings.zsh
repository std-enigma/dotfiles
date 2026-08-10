# --- Keybindings ---
# Configure custom keyboard shortcuts for Zsh's line editor (ZLE).

# Load the up/down history search widgets.
# These let you search history entries that begin with what you have typed.
# autoload -Uz up-line-or-beginning-search
# autoload -Uz down-line-or-beginning-search

# 1. Up Arrow: search backward through matching history
# Example: type "git" and press Up to cycle through previous commands starting with "git".
# bindkey '^[[A' up-line-or-beginning-search

# 2. Down Arrow: search forward through matching history
# Continues forward through commands matching the current text.
# bindkey '^[[B' down-line-or-beginning-search

# 3. Ctrl + Left Arrow: move backward one word
# bindkey '^[[1;5D' backward-word

# 4. Ctrl + Right Arrow: move forward one word
# bindkey '^[[1;5C' forward-word

# 5. Home: move the cursor to the start of the command line
# bindkey '^[[H' beginning-of-line

# 6. End: move the cursor to the end of the command line
# bindkey '^[[F' end-of-line

# 7. Ctrl + Backspace: delete the word before the cursor
# bindkey '^H' backward-kill-word
