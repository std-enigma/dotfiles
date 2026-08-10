# --- Effortless Navigation ---

# Type a directory name alone to cd into it
setopt AUTO_CD

# Push every visited directory onto the stack automatically
setopt AUTO_PUSHD

# Don't push duplicate directories onto the stack
setopt PUSHD_IGNORE_DUPS

# Swap '+'/'-' direction in the dir stack for more intuitive navigation
setopt PUSHD_MINUS

# Don't print the directory stack after pushd/popd
setopt PUSHD_SILENT

# Resolve symlinks to their true path when changing directories
setopt CHASE_LINKS

# --- Advanced Tab Completion ---

# List choices immediately on ambiguous completion
setopt AUTO_LIST

# Move cursor to end of word after completion
setopt ALWAYS_TO_END

# Complete from both ends of a word (e.g. partial matches in the middle)
setopt COMPLETE_IN_WORD

# Use menu selection when there are multiple matches (cycle with Tab)
setopt AUTO_MENU

# Treat '#', '~', and '^' as glob special characters
setopt EXTENDED_GLOB

# Offer spelling correction for commands
setopt CORRECT

# --- Safety & Protection ---

# Prevent '>' from silently overwriting files; use '>!' to force
setopt NO_CLOBBER

# Warn before running 'rm *' or 'rm path/*'
setopt RM_STAR_WAIT

# --- Shell Behavior & Usability ---

# Allow '#' comments in interactive shells
setopt INTERACTIVE_COMMENTS

# Don't kill background jobs when the shell exits
setopt NO_HUP

# Report background job status immediately when they finish
setopt NOTIFY

# Don't beep on errors or ambiguous completions
setopt NO_BEEP

# Allow functions to have local options (setopt inside a function is scoped)
setopt LOCAL_OPTIONS

# Enable parameter, command, and arithmetic expansion inside prompts
setopt PROMPT_SUBST

# Print exit value of commands with non-zero exit status
setopt PRINT_EXIT_VALUE
