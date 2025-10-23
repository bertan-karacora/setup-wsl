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

install_docker() {
    echo "Installing Docker..."

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update --quiet
    for pkg in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
        if is_installed $pkg; then
            echo "$pkg already installed"
        else
            sudo apt-get install --quiet --assume-yes $pkg
        fi
    done

    echo "Installing Docker finished"
}

configure_docker() {
    echo "Configuring Docker..."

    getent group docker >/dev/null || sudo groupadd docker
    sudo usermod -aG docker "$USER"

    echo "Configuring Docker finished"
}

main() {
    parse_args "$@"
    install_docker
    configure_docker
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
