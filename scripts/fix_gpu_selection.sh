#!/usr/bin/env bash

# If you are using a dedicated NVIDIA card this is a solution to a common problem with OpenGL.
# The effect can be tested e.g. using glxgears.

set -e -u -o pipefail

path_repo="$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")"
source "$path_repo/libs/io_utils.sh"

readonly path_repo

show_help() {
    cat <<EOF
Usage:
$(basename "${BASH_SOURCE[0]}") [-h | --help]

Fix GPU selection.
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
