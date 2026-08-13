#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Setup libs.
EOF
}

parse_args() {
    while (($#)); do
        case "${1-}" in
        -h | --help)
            show_help
            exit 0
            ;;
        -?*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            echo "Unexpected argument: $1"
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
