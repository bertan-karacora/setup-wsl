#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Setup scripts.
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
