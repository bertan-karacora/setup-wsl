#!/usr/bin/env bash

# If you are using a dedicated NVIDIA card this is a solution to a common problem with OpenGL.
# The effect can be tested e.g. using glxgears.

set -e -u -o pipefail

readonly path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

show_help() {
    echo "Usage:"
    echo "  ./fix_gpu_selection.sh [-h|--help]"
    echo
    echo "Fix GPU selection."
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

fix_gpu_selection() {
    local string_bashrc="
# Fix OpenGL rendering
export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA"

    echo "Fix GPU selection ..."

    append_if_not_contained ~/.bashrc "$string_bashrc"

    echo "Fix GPU selection finished"
}

main() {
    parse_args "$@"
    fix_gpu_selection
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
