#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

username=""

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help] username

Disable sudo password for <username>.
EOF
}

parse_args() {
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
            if [[ -z "$username" ]]; then
                username="$1"
                shift
            else
                echo "Unexpected argument: $1"
                exit 1
            fi
            ;;
        esac
    done

    if [[ -z "$username" ]]; then
        echo "Missing required argument: username"
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
