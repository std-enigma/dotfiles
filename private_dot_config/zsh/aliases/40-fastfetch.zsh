# --- Fastfetch Alias ---
# Use Kitty's graphics protocol for the Fastfetch logo when Fastfetch is
# installed.
if command -v fastfetch >/dev/null 2>&1; then
  alias fastfetch='fastfetch --logo-type kitty'
fi
