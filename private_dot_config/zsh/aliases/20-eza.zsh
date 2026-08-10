# --- Eza Aliases ---
# Replace common directory-listing commands with readable, icon-enhanced Eza
# views when Eza is installed.
if command -v eza >/dev/null 2>&1; then
  # Human-readable long listing without hidden files.
  alias l='eza -lh --icons=auto'

  # Compact one-entry-per-line listing.
  alias ls='eza -1 --icons=auto'

  # Detailed listing including hidden files, with directories grouped first.
  alias ll='eza -lha --icons=auto --sort=name --group-directories-first'

  # List directories only.
  alias ld='eza -lhD --icons=auto'

  # Display the current directory as a tree.
  alias lt='eza --icons=auto --tree'
fi
