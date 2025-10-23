#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"
source "$path_repo/libs/io_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./setup_aliases.sh [-h|--help]"
    echo
    echo "Setup bash aliases."
    echo
}

parse_args() {
    local arg=""
    while [[ "$#" -gt 0 ]]; do
        arg="$1"
        shift
        case $arg in
        -h | --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option $arg"
            exit 1
            ;;
        esac
    done
}

setup_aliases() {
    echo "Setting up bash aliases..."

    local string_bash_aliases="$(PATH_REPO=$path_repo envsubst '$PATH_REPO' < $path_repo/resources/bash_aliases.sh.template)"
    local string_bashrc="
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi"

    append_if_not_contained "$HOME/.bash_aliases" "$string_bash_aliases"
    append_if_not_contained "$HOME/.bashrc" "$string_bashrc"

    echo "Setting up bash aliases finished"
}

main() {
    parse_args "$@"
    setup_aliases
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
