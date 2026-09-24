package main

import (
    "fmt"
    "os"
    "strconv"
    "strings"
)

func parseIPv4(s string) (uint32, error) {
    parts := strings.Split(s, ".")
    if len(parts) != 4 {
        return 0, fmt.Errorf("invalid IPv4 address")
    }
    var ip uint32
    for _, part := range parts {
        n, err := strconv.Atoi(part)
        if err != nil || n < 0 || n > 255 {
            return 0, fmt.Errorf("invalid IPv4 address")
        }
        ip = (ip << 8) | uint32(n)
    }
    return ip, nil
}

func formatIPv4(v uint32) string {
    return fmt.Sprintf("%d.%d.%d.%d", (v>>24)&255, (v>>16)&255, (v>>8)&255, v&255)
}

func main() {
    if len(os.Args) != 3 {
        fmt.Fprintf(os.Stderr, "usage: %s IP PREFIX\n", os.Args[0])
        os.Exit(2)
    }

    ip, err := parseIPv4(os.Args[1])
    if err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(2)
    }
    prefix, err := strconv.Atoi(os.Args[2])
    if err != nil || prefix < 1 || prefix > 30 {
        fmt.Fprintln(os.Stderr, "prefix must be between 1 and 30")
        os.Exit(2)
    }

    // Parsing is finished. Fill in only these calculations.
    var mask uint32 = 0       // TODO
    var network uint32 = 0    // TODO
    var broadcast uint32 = 0  // TODO
    var first uint32 = 0      // TODO
    var last uint32 = 0       // TODO
    var hosts uint32 = 0      // TODO

    fmt.Printf("IP: %s\n", formatIPv4(ip))
    fmt.Printf("Netmask: %s\n", formatIPv4(mask))
    fmt.Printf("Network: %s\n", formatIPv4(network))
    fmt.Printf("Broadcast: %s\n", formatIPv4(broadcast))
    fmt.Printf("First usable: %s\n", formatIPv4(first))
    fmt.Printf("Last usable: %s\n", formatIPv4(last))
    fmt.Printf("Usable hosts: %d\n", hosts)
}
