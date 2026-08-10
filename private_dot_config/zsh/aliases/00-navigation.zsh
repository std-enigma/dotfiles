# --- Terminal Display ---
# Provide a short command for clearing the terminal screen.
alias c='clear'

# --- Directory Navigation ---
# Route cd through Zoxide so frequently visited directories can be reached by
# name while normal paths continue to work.
alias cd='z'

# Provide short aliases for moving up several parent directories at once.
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
