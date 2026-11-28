#!/usr/bin/env sh

# Expose ~/.local/bin to the whole graphical session, not just interactive shells.
if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) PATH="$HOME/.local/bin:$PATH" ;;
    esac
    export PATH
fi
