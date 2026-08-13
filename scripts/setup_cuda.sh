#!/usr/bin/env bash

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/system_utils.sh"

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Setup CUDA.
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

remove_gpg_key() {
    # Reference: https://docs.nvidia.com/cuda/wsl-user-guide/index.html
    sudo apt-key del 7fa2af80
}

cleanup() {
    rm cuda*.deb
}

# Check for versions manually:
# See https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local
setup_cuda() {
    echo "Setting up CUDA..."

    if is_installed cuda-toolkit-12-8; then
        echo "CUDA already installed"
        return 0
    fi

    remove_gpg_key

    wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg --install cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get --quiet --assume-yes install cuda-toolkit-12-8
    
    cleanup

    echo "Setting up CUDA finished"
}

setup_cudnn() {
    echo "Setting up cuDNN..."

    if is_installed cudnn9-cuda-12; then
        echo "cuDNN already installed"
        return 0
    fi

    sudo apt-get --quiet --assume-yes update
    sudo apt-get --quiet --assume-yes install zlib1g
    sudo apt-get --quiet --assume-yes install cudnn9-cuda-12

    echo "Setting up cuDNN finished"
}

main() {
    parse_args "$@"
    setup_cuda
    setup_cudnn
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
