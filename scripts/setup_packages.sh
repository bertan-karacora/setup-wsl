#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"

show_help() {
    echo "Usage:"
    echo "  ./setup_packages.sh [-h|--help]"
    echo
    echo "Setup system packages."
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

setup_packages() {
    echo "Installing packages..."

    sudo apt-get update --quiet
    cat "$path_repo/requirements_apt.txt" |
        xargs sudo apt-get install --quiet --assume-yes --no-install-recommends

    echo "Installing packages finished"
}

main() {
    parse_args "$@"
    setup_packages
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
