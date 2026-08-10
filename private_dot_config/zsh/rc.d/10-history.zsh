# --- State Location ---
# Define where the history file will be saved.
HISTFILE="$XDG_STATE_HOME/zsh/history"

# Ensure the directory containing the history file exists before Zsh writes to it.
# (${HISTFILE:h} is a Zsh path modifier meaning "the directory containing this path")
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# --- History Sizes ---
# Set the maximum number of events to load/save.
HISTSIZE=10000
SAVEHIST=10000

# --- History Options ---

# 1. Appending instead of overwriting
# Append to the history file rather than replacing it.
setopt APPEND_HISTORY

# 2. Extended timestamps
# Save the time and execution duration of each command in the history file.
setopt EXTENDED_HISTORY

# 3. Removing older duplicates
# If a new command line duplicates an older one, remove the older line from history.
setopt HIST_IGNORE_ALL_DUPS

# 4. Ignoring consecutive duplicates
# Do not enter commands into history if they are duplicates of the previous command.
setopt HIST_IGNORE_DUPS

# 5. Ignoring commands deliberately prefixed by a space
# Do not record an event starting with a space (useful for hiding passwords/secrets).
setopt HIST_IGNORE_SPACE

# 6. Sharing history between active terminals
# Share command history list among all active sessions in real-time.
# (Note: Remove this if you prefer command history to remain isolated per window)
setopt SHARE_HISTORY

# --- Permissions & Security ---
# Secure the history file so it is only readable/writable by the owner.
# Runs only if the file already exists. Remember not to commit this file to Git.
[[ -f "$HISTFILE" ]] && chmod 600 "$HISTFILE"
