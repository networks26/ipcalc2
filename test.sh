#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: $0 'command to run'" >&2
    exit 2
fi

runner=$1
base=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
fail=0

while read -r ip prefix; do
    expected=$(python3 - "$ip" "$prefix" <<'PY'
import ipaddress, sys
ip = ipaddress.IPv4Address(sys.argv[1])
prefix = int(sys.argv[2])
net = ipaddress.IPv4Network(f"{ip}/{prefix}", strict=False)
print(f"IP: {ip}")
print(f"Netmask: {net.netmask}")
print(f"Network: {net.network_address}")
print(f"Broadcast: {net.broadcast_address}")
print(f"First usable: {net.network_address + 1}")
print(f"Last usable: {net.broadcast_address - 1}")
print(f"Usable hosts: {net.num_addresses - 2}")
PY
)

    actual=$(sh -c "$runner '$ip' '$prefix'") || {
        echo "FAIL: $ip/$prefix (program exited with error)"
        fail=1
        continue
    }

    if [ "$actual" = "$expected" ]; then
        echo "PASS: $ip/$prefix"
    else
        echo "FAIL: $ip/$prefix"
        echo "--- expected"
        printf '%s\n' "$expected"
        echo "--- got"
        printf '%s\n' "$actual"
        fail=1
    fi
done < "$base/tests.txt"

exit "$fail"
