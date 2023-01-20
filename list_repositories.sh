#!/bin/sh -e

clean() {
  rm -f .include .filter
}

trap clean EXIT INT

grep -v '^[# ].*' filter | sort -u > .filter
grep -v '^[# ].*' include | sort -u > .include

{
  curl 'https://api.github.com/search/repositories?q=topic:kiss-repo&per_page=100' |
    jq -r '.items[].clone_url'
  curl 'https://codeberg.org/api/v1/repos/search?q=kiss-repo&topic=true' |
    jq -r '.data[].clone_url'
} >> .include

sort -u .include >_
mv _ .include

printf "%d repositories found\n" "$(wc -l < .include)" >&2

comm -23 .include .filter
