set -a

append2file() {
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
        append2file "$path" "$string"
    else
        true
    fi
}
