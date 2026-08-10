# --- Directory Creation & Navigation ---
# Create a directory and move into it in one command.
mkcd() {
  if (($# != 1)); then
    print -u2 -- "Usage: mkcd <directory>"
    return 1
  fi

  command mkdir -p -- "$1" && builtin cd -- "$1"
}

# Create one or more directories, including any missing parent directories.
create-dir() {
  if (($# == 0)); then
    print -u2 -- "Usage: create-dir <directory...>"
    return 1
  fi

  command mkdir -p -- "$@"
}

# --- File Creation ---
# Create files together with any parent directories that do not exist yet.
create-file() {
  if (($# == 0)); then
    print -u2 -- "Usage: create-file <file...>"
    return 1
  fi

  local file
  for file in "$@"; do
    command mkdir -p -- "${file:h}" && command touch -- "$file" || return 1
  done
}

# --- Safer File Operations ---
# Copy files recursively and ask before overwriting an existing destination.
copy() {
  if (($# < 2)); then
    print -u2 -- "Usage: copy <source...> <destination>"
    return 1
  fi

  command cp -ri -- "$@"
}

# Move files and ask before overwriting an existing destination.
move() {
  if (($# < 2)); then
    print -u2 -- "Usage: move <source...> <destination>"
    return 1
  fi

  command mv -i -- "$@"
}

# Remove files or directories recursively and confirm each removal.
remove() {
  if (($# == 0)); then
    print -u2 -- "Usage: remove <path...>"
    return 1
  fi

  command rm -rI -- "$@"
}
