#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Disable apt marketing message.
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
