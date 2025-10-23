#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"
source "$path_repo/libs/io_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./setup_libs.sh [-h|--help]"
    echo
    echo "Setup bash libs."
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

setup_libs() {
    echo "Setting up bash functions..."

    local string_bash_libs="$(PATH_REPO=$path_repo envsubst '$PATH_REPO' < $path_repo/resources/bash_libs.sh.template)"
    local string_bashrc="
if [ -f ~/.bash_libs ]; then
    . ~/.bash_libs
fi"

    append_if_not_contained "$HOME/.bash_libs" "$string_bash_libs"
    append_if_not_contained "$HOME/.bashrc" "$string_bashrc"

    echo "Setting up bash functions finished"
}

main() {
    parse_args "$@"
    setup_libs
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
