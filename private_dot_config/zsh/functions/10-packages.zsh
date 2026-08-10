# --- Orphaned Package Cleanup ---
# Collect orphaned package names first so each one is passed to the package
# manager as a separate positional argument instead of through standard input.
if [[ -n "${aurhelper:-}" && -n "${package_admin:-}" ]]; then
  po() {
    local orphan_output
    local -a orphan_packages

    orphan_output="$("$aurhelper" -Qtdq)"

    if [[ -z "$orphan_output" ]]; then
      print -- "No orphaned packages found."
      return 0
    fi

    orphan_packages=("${(@f)orphan_output}")
    ${=package_admin} -Rns -- "${orphan_packages[@]}"
  }
fi
