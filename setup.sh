#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname "$(realpath "$BASH_SOURCE")")"
source "$path_repo/libs/io_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./setup.sh [-h|--help]"
    echo
    echo "Setup the system."
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

check_wsl() {
    local venv="$(systemd-detect-virt)"

    if [[ "$venv" != "wsl" ]]; then
        echo "This script is only for WSL"
        exit 1
    fi
}

main() {
    parse_args "$@"
    check_wsl
    ./scripts/setup_libs.sh
    ./scripts/setup_aliases.sh
    ./scripts/setup_scripts.sh
    ./scripts/setup_packages.sh
    sudo scripts/disable_sudo_password.sh "$USER"
    ./scripts/disable_apt_marketing_message.sh
    ./scripts/fix_gpu_selection.sh
    ./scripts/setup_git.sh
    ./scripts/setup_ssh.sh
    ./scripts/setup_docker.sh
    ./scripts/setup_cuda.sh
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
