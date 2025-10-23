set -a

is_installed() {
    local packages="$@"
    local is_installed=""

    for package in $packages; do
        is_installed="$(dpkg-query --show --showformat='${db:Status-Status}\n' "$package" 2>/dev/null)"
        if [[ "$is_installed" != "installed" ]]; then
            return 1
        fi
    done

    return 0
}

set +a
