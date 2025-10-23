#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"
source "$path_repo/libs/io_utils.sh"

username=""

show_help() {
    echo "Usage:"
    echo "  ./disable_sudo_password.sh [-h|--help] <username>"
    echo
    echo "Disable sudo password for <username>."
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
            if [[ -z "$username" ]]; then
                username="$arg"
            else
                echo "Unknown option $arg"
                exit 1
            fi
            ;;
        esac
    done

    if [[ -z "$username" ]]; then
        echo "Username is required"
        exit 1
    fi
}

disable_sudo_password() {
    echo "Disabling password..."

    local file="/etc/sudoers.d/$username"
    local entry="$username ALL=(ALL) NOPASSWD:ALL"

    if contains $file $entry; then
        echo "Sudo password for user $username already disabled"
        return 0
    fi

    echo "$entry" | EDITOR='tee -a' visudo --quiet --file="$file" >/dev/null
    echo "Disabling password finished"
}

main() {
    parse_args "$@"
    disable_sudo_password
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
