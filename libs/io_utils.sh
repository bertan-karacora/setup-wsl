set -a

append_to_file() {
    local path="$1"
    local string="$2"

    cat >>"$path" <<EOF
$string
EOF
}

contains() {
    local path="$1"
    local query="$2"
    local query_trimmed="$(echo "$query" | tr -d '\n')"

    [[ -f "$path" ]] && grep "$query_trimmed" --fixed-strings --quiet < <(tr -d '\n' <"$path")
}

append_if_not_contained() {
    local path="$1"
    local string="$2"

    if ! contains "$path" "$string"; then
        append_to_file "$path" "$string"
    else
        return 0
    fi
}

ask_yesno() {
    while true; do
        read -p "Do you wish to use the recommended settings? " yesno
        case "$yesno" in
        [Yy]*)
            return 0
            ;;
        [Nn]*)
            return 1
            ;;
        *)
            echo "Please answer yes or no."
            ;;
        esac
    done
}

set +a
