#!/usr/bin/env bash

# For MSys2 console
#   Usage:
#     Copy 'pas' and 'pas.rb' to ~/bin/


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ruby "${SCRIPT_DIR}/pas.rb" $*
