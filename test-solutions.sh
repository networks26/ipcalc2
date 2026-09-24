#!/bin/sh
set -u

root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
failed=0

run_one() {
    name=$1
    compiler=$2
    dir=$3

    if ! command -v "$compiler" >/dev/null 2>&1; then
        echo "SKIP: $name ($compiler not installed)"
        return
    fi

    echo "===== $name ====="
    if make -C "$root/solutions/$dir" clean >/dev/null 2>&1 \
       && make -C "$root/solutions/$dir" \
       && make -C "$root/solutions/$dir" test; then
        echo "OK: $name"
    else
        echo "FAIL: $name"
        failed=1
    fi
    echo
}

run_one "C" cc c
run_one "Python" python3 python
run_one "Java" javac java
run_one "Go" go go
run_one "Pascal" fpc pascal
run_one "Oberon (VOC)" voc oberon

if [ "$(uname -m)" = "x86_64" ] && command -v cc >/dev/null 2>&1; then
    echo "===== x86-64 assembly ====="
    if make -C "$root/solutions/asm" clean >/dev/null 2>&1 \
       && make -C "$root/solutions/asm" \
       && make -C "$root/solutions/asm" test; then
        echo "OK: x86-64 assembly"
    else
        echo "FAIL: x86-64 assembly"
        failed=1
    fi
else
    echo "SKIP: x86-64 assembly (not an x86_64 host or no C toolchain)"
fi

exit "$failed"
