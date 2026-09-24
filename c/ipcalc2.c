#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static int parse_ipv4(const char *s, uint32_t *out)
{
    unsigned a, b, c, d;
    char tail;

    if (sscanf(s, "%u.%u.%u.%u%c", &a, &b, &c, &d, &tail) != 4)
        return 0;
    if (a > 255 || b > 255 || c > 255 || d > 255)
        return 0;

    *out = ((uint32_t)a << 24) |
           ((uint32_t)b << 16) |
           ((uint32_t)c << 8)  |
           (uint32_t)d;
    return 1;
}

static void print_ipv4(uint32_t v)
{
    printf("%u.%u.%u.%u",
           (v >> 24) & 255,
           (v >> 16) & 255,
           (v >> 8) & 255,
           v & 255);
}

int main(int argc, char **argv)
{
    uint32_t ip;
    unsigned prefix;

    if (argc != 3) {
        fprintf(stderr, "usage: %s IP PREFIX\n", argv[0]);
        return 2;
    }

    if (!parse_ipv4(argv[1], &ip)) {
        fprintf(stderr, "invalid IPv4 address\n");
        return 2;
    }

    prefix = (unsigned)strtoul(argv[2], NULL, 10);
    if (prefix < 1 || prefix > 30) {
        fprintf(stderr, "prefix must be between 1 and 30\n");
        return 2;
    }

    /* Command-line parsing is finished.  The useful inputs are now:
       ip      - the IPv4 address as one 32-bit integer
       prefix  - the CIDR prefix length

       Fill in only the calculations below. */

    uint32_t mask      = 0;  /* TODO */
    uint32_t network   = 0;  /* TODO */
    uint32_t broadcast = 0;  /* TODO */
    uint32_t first     = 0;  /* TODO */
    uint32_t last      = 0;  /* TODO */
    uint32_t hosts     = 0;  /* TODO */

    printf("IP: "); print_ipv4(ip); putchar('\n');
    printf("Netmask: "); print_ipv4(mask); putchar('\n');
    printf("Network: "); print_ipv4(network); putchar('\n');
    printf("Broadcast: "); print_ipv4(broadcast); putchar('\n');
    printf("First usable: "); print_ipv4(first); putchar('\n');
    printf("Last usable: "); print_ipv4(last); putchar('\n');
    printf("Usable hosts: %u\n", hosts);
    return 0;
}
