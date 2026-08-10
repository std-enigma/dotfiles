# --- Completion Path ---
# Add your custom completion directory before Oh My Zsh initializes completion.
# This lets Zsh find any completion functions you place in $ZDOTDIR/completions.
fpath=("$ZDOTDIR/completions" $fpath)

# --- Completion Dump Cache ---
# Store the completion cache in XDG cache instead of the default location.
# Oh My Zsh will read this in the current shell, so exporting is not necessary.
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"

# --- Completion Preferences ---
# Enable menu selection when multiple completion matches are available.
# This makes tab completion easier to browse and choose from.
zstyle ':completion:*' menu select

# --- Optional Tweaks ---

# Case-insensitive matching for completions.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Group completions by category with cleaner display.
zstyle ':completion:*' group-name ''

# Show colors in completion listings when LS_COLORS is available.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Include hidden files in completion where appropriate.
zstyle ':completion:*' fake-files null
zstyle ':completion:*' special-dirs true

# Cache completion results to speed up repeated completion queries.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
