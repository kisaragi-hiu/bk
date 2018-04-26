#!/bin/bash

scratch=$(mktemp --directory)
trap 'rm -r $scratch' INT EXIT
cd "$scratch" || exit 127
export BK_FILE="test.json"

check () {
    local title="$1"; shift
    if test "$@"; then
        echo "Success: $title"
    else
        echo "Fail: $title"
    fi
}

check "bk --help" \
      -n "$(bk --help)"

bk --init
check "bk --init creates bk store" \
      "$(cat "test.json")" == "{}"

bk foo bar
check "foo has been set to bar" \
      "$(bk foo)" == "bar"

check "foo is the only entry" \
      "$(bk --list)" == "foo"

check "non-existent key returns empty string" \
      "$(bk no)" == ""

bk --delete foo
check "foo has been deleted" \
      "$(cat "test.json")" == "{}"

rm "test.json"
bk foo bar
check "bk store is implicitly created" \
      -f "test.json"
check "foo has been set to bar after implicit store creation" \
      "$(bk foo)" == "bar"
