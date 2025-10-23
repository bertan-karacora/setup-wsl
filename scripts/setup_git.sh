#!/usr/bin/env bash

set -e -u -o pipefail

readonly path_repo="$(dirname $(dirname $(realpath $BASH_SOURCE)))"
source "$path_repo/libs/system_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./setup_git.sh [-h|--help]"
    echo
    echo "Setup git."
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

install_git() {
    echo "Installing Git..."

    if is_installed git; then
        echo "Git already installed"
        return 0
    fi

    sudo apt-get update --quiet
    sudo apt-get install git --quiet --assume-yes
    echo "Installing Git finished"
}

configure_git() {
    echo "Configuring git..."

    local string_config_git="$(< $path_repo/configs/config_git_wsl.template)"

    touch "$HOME/.gitconfig"

    append_if_not_contained "$HOME/.gitconfig" "$string_config_git"

    echo "Configuring git finished"
}

main() {
    parse_args "$@"
    install_git
    configure_git
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
