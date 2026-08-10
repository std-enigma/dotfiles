# --- System Path Configuration ---
# Ensure that the 'path' array and the 'PATH' environment variable only contain
# unique entries, automatically stripping any duplicates that might be added.
typeset -U path PATH

# Prepend the user's local bin directory to the path if it exists,
# giving local binaries priority over system-wide ones.
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)

# Export the updated PATH variable to make it available to all child processes.
export PATH
