set -a

remove_zone_identifiers() {
    find . -type f -name "*:Zone.Identifier" -print -delete
}

set +a
