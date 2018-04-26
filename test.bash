#!/bin/bash

scratch=$(mktemp --directory)
trap 'rm -r $scratch' INT EXIT
cd "$scratch" || exit 127
export BK_FILE="test.json"
check_count=0
check_fail_count=0
check_success_count=0

check () {
    ((check_count+=1))
    local title="$1"; shift
    if test "$@"; then
        echo "Success: $title"
        ((check_success_count+=1))
        return 0
    fi
    echo "Fail: $title"
    ((check_fail_count+=1))
    return 1
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

echo "$check_success_count / $check_count succeeded, $check_fail_count failed."
