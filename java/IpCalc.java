public class IpCalc {
    static long parseIPv4(String s) {
        String[] p = s.split("\\.", -1);
        if (p.length != 4) throw new IllegalArgumentException("invalid IPv4 address");
        long value = 0;
        for (String part : p) {
            int octet = Integer.parseInt(part);
            if (octet < 0 || octet > 255) throw new IllegalArgumentException("invalid IPv4 address");
            value = (value << 8) | octet;
        }
        return value;
    }

    static String formatIPv4(long v) {
        return String.format("%d.%d.%d.%d",
                (v >>> 24) & 255, (v >>> 16) & 255,
                (v >>> 8) & 255, v & 255);
    }

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("usage: java IpCalc IP PREFIX");
            System.exit(2);
        }

        long ip;
        int prefix;
        try {
            ip = parseIPv4(args[0]);
            prefix = Integer.parseInt(args[1]);
        } catch (RuntimeException e) {
            System.err.println(e.getMessage());
            return;
        }

        if (prefix < 1 || prefix > 30) {
            System.err.println("prefix must be between 1 and 30");
            System.exit(2);
        }

        // Parsing is finished. Fill in only these calculations.
        long mask = 0;       // TODO
        long network = 0;    // TODO
        long broadcast = 0;  // TODO
        long first = 0;      // TODO
        long last = 0;       // TODO
        long hosts = 0;      // TODO

        System.out.println("IP: " + formatIPv4(ip));
        System.out.println("Netmask: " + formatIPv4(mask));
        System.out.println("Network: " + formatIPv4(network));
        System.out.println("Broadcast: " + formatIPv4(broadcast));
        System.out.println("First usable: " + formatIPv4(first));
        System.out.println("Last usable: " + formatIPv4(last));
        System.out.println("Usable hosts: " + hosts);
    }
}
