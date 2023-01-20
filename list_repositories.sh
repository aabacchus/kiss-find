#!/bin/sh -e

warn() {
  echo "$@" >&2
}

clean() {
  rm -f .include .filter
}

trap clean EXIT INT
clean

grep -v '^[# ].*' filter | sort -u > .filter
grep -v '^[# ].*' include | sort -u > .include

{
  curl 'https://api.github.com/search/repositories?q=topic:kiss-repo' | 
    jq '.items[].html_url'
  curl 'https://codeberg.org/api/v1/repos/search?q=kiss-repo&topic=true' | 
    jq '.data[].html_url'
} | tr -d '"' >> .include

echo "$(wc -l < .include) repsitories found" >&2

sort -u .include >_
mv _ .include

comm -23 .include .filter
