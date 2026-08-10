# --- Interactive Startup Display ---
# Show one visual greeting per interactive terminal session. The terminal check
# avoids emitting artwork when standard output is redirected or piped.
if [[ -o interactive && -t 1 && -z "${PERSONAL_ART_SHOWN:-}" ]]; then
  # Mark the greeting as shown so re-sourcing the configuration stays quiet.
  export PERSONAL_ART_SHOWN=1

  # Prefer a Pokémon renderer, then fall back to Fastfetch when neither one is
  # installed. Use Kitty graphics only when the terminal supports image output.
  if command -v pokego >/dev/null 2>&1; then
    pokego --no-title -r 1,3,6
  elif command -v pokemon-colorscripts >/dev/null 2>&1; then
    pokemon-colorscripts --no-title -r 1,3,6
  elif command -v fastfetch >/dev/null 2>&1; then
    if do_render "image"; then
      fastfetch --logo-type kitty
    else
      fastfetch
    fi
  fi
fi
