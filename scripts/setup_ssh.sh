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

Setup ssh.
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

generate_sshkey() {
    echo "Generating SSH keys..."

    local path_key="$HOME/.ssh/id_ed25519"

    if [[ -f "$path_key" ]]; then
        echo "Key already exists at $path_key"
        return 0
    fi

    read_comment

    ssh-keygen -t ed25519 -C "$comment" -f "$path_key"

    echo "Generating SSH keys finished"
}

configure_ssh() {
    echo "Configuring SSH..."

    local string_config_ssh="$(< $path_repo/configs/config_ssh.template)"

    mkdir --parents "$HOME/.ssh"
    touch "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"

    append_if_not_contained "$HOME/.ssh/config" "$string_config_ssh"

    echo "Configuring SSH finished"
}

main() {
    parse_args "$@"
    generate_sshkey
    configure_ssh
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
