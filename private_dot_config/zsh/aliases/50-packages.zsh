# --- Package Manager Selection ---
# Prefer Paru for repository and AUR packages, fall back to Yay, then use
# Pacman when neither AUR helper is installed.
typeset -g aurhelper=""
typeset -g package_admin=""

if command -v paru >/dev/null 2>&1; then
  aurhelper="paru"
  package_admin="paru"
elif command -v yay >/dev/null 2>&1; then
  aurhelper="yay"
  package_admin="yay"
elif command -v pacman >/dev/null 2>&1; then
  aurhelper="pacman"

  # Pacman requires elevated privileges for operations that change packages.
  if command -v sudo >/dev/null 2>&1; then
    package_admin="sudo pacman"
  elif command -v doas >/dev/null 2>&1; then
    package_admin="doas pacman"
  else
    package_admin="pacman"
  fi
fi

# --- Package Management Aliases ---
# Define these shortcuts only when a supported package manager was found.
if [[ -n "$aurhelper" ]]; then
  # Install one or more packages.
  alias pi="$package_admin -S"

  # Uninstall a package together with unused dependencies and configuration.
  alias un="$package_admin -Rns"

  # Update repository packages and AUR packages when the selected helper
  # supports them.
  alias up="$package_admin -Syu"

  # List packages that have updates available without installing them.
  alias pu="$aurhelper -Qu"

  # Search the locally installed package database.
  alias pl="$aurhelper -Qs"

  # Search packages available from configured repositories and the AUR when
  # the selected helper supports it.
  alias pa="$aurhelper -Ss"

  # Show detailed information about an installed package.
  alias pinfo="$aurhelper -Qi"

  # List every file installed by a package.
  alias pfiles="$aurhelper -Ql"

  # Find which installed package owns a particular file.
  alias powner="$aurhelper -Qo"

  # Remove package files from the local cache.
  alias pc="$package_admin -Sc"
fi
