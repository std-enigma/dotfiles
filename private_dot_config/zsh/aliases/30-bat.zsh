# --- Bat Aliases ---
# Define enhanced help and file-viewing aliases only when Bat is installed.
if command -v bat >/dev/null 2>&1; then
  # Pipe any command ending in --help through Bat for highlighted, unpaged output.
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain --paging=never --color always'

  # Use Bat as a drop-in replacement for common file viewing commands.
  alias cat='bat --style=plain --paging=never --color auto'
  alias view='bat --color auto'
fi
