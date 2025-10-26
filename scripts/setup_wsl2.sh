#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"

comment=""

show_help() {
    echo "Usage:"
    echo "  ./setup_wsl2.sh [-h|--help]"
    echo
    echo "Setup WSL 2."
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
