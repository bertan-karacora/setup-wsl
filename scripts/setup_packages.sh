#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Setup system packages.
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
