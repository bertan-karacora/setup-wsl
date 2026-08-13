#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

comment=""

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Setup WSL 2.
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

read_comment() {
    echo "Comment:"
    read -r comment
}

configure_wsl2() {
    echo "Configuring WSL 2..."

    local string_config_wsl2="$(< $path_repo/configs/config_wsl2.template)"

    touch "/mnt/c/Users/$USER/.wslconfig"

    append_if_not_contained "/mnt/c/Users/$USER/.wslconfig" "$string_config_wsl2"

    echo "Configuring WSL 2 finished"
}

main() {
    parse_args "$@"
    configure_wsl2
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
