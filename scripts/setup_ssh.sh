#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"

comment=""

show_help() {
    echo "Usage:"
    echo "  ./setup_ssh.sh [-h|--help]"
    echo
    echo "Setup ssh."
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
