#!/bin/bash

bold="$(tput bold)"
normal="$(tput sgr0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
white="$(tput setaf 15)"

bin=bk
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
        echo "${bold}${green}Success: ${white}$title${normal}"
        ((check_success_count+=1))
        return 0
    fi
    echo "${bold}${red}Fail: ${white}$title${normal}"
    ((check_fail_count+=1))
    return 1
}

check "$bin --help" \
      -n "$($bin --help)"

$bin --init
check "$bin --init creates bk store" \
      "$(cat "test.json")" == "{}"

$bin foo bar
check "foo has been set to bar" \
      "$($bin foo)" == "bar"

check "foo is the only entry" \
      "$($bin --list)" == "foo"

check "non-existent key returns empty string" \
      "$($bin no)" == ""

$bin --delete foo
check "foo has been deleted" \
      "$(cat "test.json")" == "{}"

rm "test.json"
$bin foo bar
check "bk store is implicitly created" \
      -f "test.json"
check "foo has been set to bar after implicit store creation" \
      "$($bin foo)" == "bar"

echo "$check_success_count / $check_count succeeded, $check_fail_count failed."
