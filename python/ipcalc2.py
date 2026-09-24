#!/usr/bin/env python3
import sys


def parse_ipv4(text):
    parts = text.split('.')
    if len(parts) != 4:
        raise ValueError('invalid IPv4 address')
    octets = [int(x) for x in parts]
    if any(x < 0 or x > 255 for x in octets):
        raise ValueError('invalid IPv4 address')
    a, b, c, d = octets
    return (a << 24) | (b << 16) | (c << 8) | d


def format_ipv4(value):
    return '.'.join(str((value >> shift) & 255) for shift in (24, 16, 8, 0))


def main():
    if len(sys.argv) != 3:
        print(f'usage: {sys.argv[0]} IP PREFIX', file=sys.stderr)
        return 2

    try:
        ip = parse_ipv4(sys.argv[1])
        prefix = int(sys.argv[2])
    except ValueError as exc:
        print(exc, file=sys.stderr)
        return 2

    if not 1 <= prefix <= 30:
        print('prefix must be between 1 and 30', file=sys.stderr)
        return 2

    # Parsing is finished. Fill in only these calculations.
    mask = 0       # TODO
    network = 0    # TODO
    broadcast = 0  # TODO
    first = 0      # TODO
    last = 0       # TODO
    hosts = 0      # TODO

    print(f'IP: {format_ipv4(ip)}')
    print(f'Netmask: {format_ipv4(mask)}')
    print(f'Network: {format_ipv4(network)}')
    print(f'Broadcast: {format_ipv4(broadcast)}')
    print(f'First usable: {format_ipv4(first)}')
    print(f'Last usable: {format_ipv4(last)}')
    print(f'Usable hosts: {hosts}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
