#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"
source "$path_repo/libs/io_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./setup_scripts.sh [-h|--help]"
    echo
    echo "Setup bash scripts."
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

setup_scripts() {
    echo "Setting up scripts..."

    local string_bashrc="
export PATH=\$PATH:$path_repo/scripts"

    append_if_not_contained "$HOME/.bashrc" "$string_bashrc"

    echo "Setting up scripts finished"
}

main() {
    parse_args "$@"
    setup_scripts
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
