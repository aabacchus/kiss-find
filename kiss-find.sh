#!/bin/sh -e
# Search for packages across every known repository
# kiss-find version 2.1

DB_PATH="${XDG_CACHE_HOME:-${HOME}/.cache}"/kiss-find/db.csv
UPDATE_URL="https://aabacchus.github.io/kiss-find/db.csv"

help() {
    printf "usage: kiss-find [-u] <query>\n"
    printf "search for <query> in packages across every known repository\n"
    printf "\t-u\tUpdate package database\n"
}

update() {
    # taken from kiss
    cmd_get=${KISS_GET:-"$(
        command -v aria2c ||
        command -v axel   ||
        command -v curl   ||
        command -v wget   ||
        command -v wget2
    )"} || {
        printf ":: No download utility found (aria2c, axel, curl, wget, wget2)\n" >&2
        exit 1
    }

    tmpfile="${KISS_TMPDIR:-/tmp}/kiss-find-db.csv"
    rm -f "$tmpfile"

    set -- "$tmpfile" "$UPDATE_URL"
    # Set the arguments based on found download utility.
    case ${cmd_get##*/} in
        aria2c|axel) set -- -o   "$@" ;;
               curl) set -- -fLo "$@" ;;
         wget|wget2) set -- -O   "$@" ;;
    esac

    "$cmd_get" "$@" || {
        printf ":: Failed to download\n" >&2
        rm -f "$tmpfile"
        exit 1
    }

    mv -f "$tmpfile" "$DB_PATH"
    printf ":: Update done\n" >&2
}

mkdir -p "$(dirname "$DB_PATH")"

case "$1" in
    "" | "-h"*)
        help
        exit
    ;;
    "-u"*)
        update
        shift
        [ "$1" = "" ] && exit
    ;;
esac

if [ ! -f "$DB_PATH" ]; then
    printf ":: Please run 'kiss-find -u' to download the latest database\n" >&2
    exit 1
fi

${KISS_FIND_GREP:-grep} "$@" "$DB_PATH" | sort |
if [ -t 1 ] && command -v column >/dev/null 2>&1; then
    column -t -s',';
else
    cat;
fi
