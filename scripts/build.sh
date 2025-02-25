#!/bin/bash

set -e

ROOT=$(git rev-parse --show-toplevel)

usage_exit() {
    echo "Usage: $0 [-r] [-o dir]" 1>&2
    exit 1
}

VERSION=debug

# while getopts orh OPT; do
while getopts ro:h OPT; do
    case $OPT in
        o) output=${OPTARG}
            ;;
        r) VERSION=release
            ;;
        h) usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done

shift $((OPTIND - 1))

OUTPUT=${output:-$ROOT/bin}
[ ! -d $OUTPUT ] && mkdir -p $OUTPUT

cd ${ROOT}/crates
make ${VERSION}
mv ./youki_bin ${OUTPUT}/youki

cd ${ROOT}/tests/rust-integration-tests
if [ ${VERSION} = release ]; then
    make FLAG=--${VERSION} all
else
    make all
fi
mv ./runtimetest_bin ${OUTPUT}/runtimetest
mv ./integration_test_bin ${OUTPUT}/integration_test

exit 0
