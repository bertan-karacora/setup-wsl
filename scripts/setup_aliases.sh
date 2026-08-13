#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Setup aliases.
EOF
}

parse_params() {
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
