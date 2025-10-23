#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"
source "$path_repo/libs/io_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./disable_apt_marketing_message.sh [-h|--help]"
    echo
    echo "Disable apt marketing message."
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

disable_apt_marketing_message() {
    echo "Disabling apt marketing message..."

    sudo sed -i'' -e 's/^\(\s\+\)\([^#]\)/\1# \2/' /etc/apt/apt.conf.d/20apt-esm-hook.conf

    echo "Disabling apt marketing message finished"
}

main() {
    parse_args "$@"
    disable_apt_marketing_message
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi