# Network Programming Lab #3 — IPv4 Subnet Calculator

In the previous labs you used tools such as `ipcalc`, `ping`, and `traceroute`. You also learned how an IPv4 address and a netmask are related, and how the network address is calculated with a bitwise AND operation.

For this lab you will turn that calculation into a small program.

Before starting, read the notes from class:

https://github.com/networks26/BBS/blob/main/2/ip2.txt

The important ideas are:

```text
network   = IP AND mask
broadcast = IP OR (NOT mask)
```

For this lab we only use prefixes `/1` through `/30`. `/31` and `/32` are useful in real networks, but they have special rules and are outside this exercise.

---

## Goal

Write a program that accepts an IPv4 address and a prefix length:

```sh
./ipcalc2 192.168.1.42 28
```

and prints:

```text
IP: 192.168.1.42
Netmask: 255.255.255.240
Network: 192.168.1.32
Broadcast: 192.168.1.47
First usable: 192.168.1.33
Last usable: 192.168.1.46
Usable hosts: 14
```

You do **not** need to write the command-line parser. Starter programs are provided. They already:

- read the IP address from the command line;
- read the prefix length;
- convert the IPv4 address into a 32-bit value;
- check basic input errors;
- contain code for printing an IPv4 address.

Your job is to fill in the subnet calculations marked `TODO`.

---

## Task 1 — Calculate One Network by Hand

Before programming, calculate this network yourself:

```text
IP:     192.168.10.77
Prefix: /27
```

Write the IP address in binary:

Oh, how to convert?

Look:
```
echo "obase=2; ibase=10; 192" | bc
```

To convert binary to decimal:

```
echo "ibase=2; 101010" | bc
```


```text
IP:
____________________________________________________
```

Write the `/27` mask in binary:

```text
Mask:
____________________________________________________
```

Apply bitwise AND:

```text
IP:       __________________________________________
Mask:     __________________________________________
          -------------------------------------------
Network:  __________________________________________
```

Now write the answers in decimal:

```text
Netmask:        ______________________________
Network:        ______________________________
Broadcast:      ______________________________
First usable:   ______________________________
Last usable:    ______________________________
Usable hosts:   ______________________________
```

Check your calculation with the system tool:

```sh
ipcalc 192.168.10.77/27
```


## Task 2 — Choose a Programming Language

Choose **one** directory:

```text
c/
python/
java/
go/
pascal/
asm/
```

The networking algorithm is the same in every language.

The assembly version is x86-64 GNU assembly for Linux. It uses the C library for input/output: `sscanf()` parses the four IPv4 octets, `strtol()` parses the prefix, and `printf()` prints the result. The subnet arithmetic itself is done in assembly.

Enter your chosen directory, for example:

```sh
cd c
```

Build the starter:

```sh
make
```

Run the example:

```sh
make run
```

The starter should run, but most answers will initially be `0.0.0.0` because the calculations are unfinished.

---

## Task 3 — Complete the Subnet Calculator

Find the variables marked `TODO` in your source file.

The inputs have already been parsed for you:

```text
ip      = IPv4 address represented as 32 bits
prefix  = number of network bits
```

You need to calculate:

```text
mask
network
broadcast
first usable address
last usable address
number of usable hosts
```

Think about these questions before writing code:

1. If the prefix is `/28`, how many host bits are there?
2. How can you create a 32-bit value with 28 leading `1` bits?
3. Which bitwise operation gives the network address?
4. Which bits must be set to `1` to obtain the broadcast address?
5. Why is the first usable address `network + 1`?
6. Why is the last usable address `broadcast - 1`?
7. Why is the normal usable-host calculation `2^(host bits) - 2`?

Do **not** call `ipcalc` from your program. Your program must perform the calculation itself.

After editing, rebuild and run:

```sh
make
make run
```

---

## Task 4 — Test Your Program

A file called `tests.txt` is provided in the parent directory:

```sh
cat ../tests.txt
```

You should see several IP/prefix pairs.

Run the automatic tests:

```sh
make test
```

The starter version should fail. After your calculations are correct, every test should say `PASS`.

Example:

```text
PASS: 192.168.1.42/24
PASS: 192.168.1.42/28
...
```

Do not modify `test.sh` to make your program pass.

---

## Task 5 — Verify with `ipcalc`

Choose at least two entries from `tests.txt` and compare your program with the real `ipcalc` utility.

For example:

```sh
./ipcalc2 192.168.1.42 28
ipcalc 192.168.1.42/28
```

For Python use:

```sh
python3 ipcalc2.py 192.168.1.42 28
```

For Java use:

```sh
java IpCalc 192.168.1.42 28
```


## Task 6 — Run All Test Networks with a Shell Loop

You already used `while read` in the previous lab. Now use it to run your own program repeatedly.

First, just read the input file:

```sh
while read ip prefix; do
    echo "$ip/$prefix"
done < ../tests.txt
```

Now run your program for every line.

For C, Go, Pascal, or assembly:

```sh
while read ip prefix; do
    echo "===== $ip/$prefix ====="
    ./ipcalc2 "$ip" "$prefix"
done < ../tests.txt
```

For Python replace `./ipcalc2` with:

```text
python3 ipcalc2.py
```

For Java replace it with:

```text
java IpCalc
```


When it works, run it again and save the complete output with `tee`:

```sh
while read ip prefix; do
    echo "===== $ip/$prefix ====="
    ./ipcalc2 "$ip" "$prefix"
done < ../tests.txt | tee results.txt
```

Use the correct command for your chosen language.

Read the result:

```sh
cat results.txt
```

Count its lines:

```sh
wc -l results.txt
```

Show only calculated network addresses:

```sh
grep '^Network:' results.txt
```

Write the number of lines in `results.txt`:

```text
____________________
```

---
## Challenge — Same Network or Router?

Suppose your machine is:

```text
192.168.10.17/27
```

Consider these destinations:

```text
192.168.10.29
192.168.10.35
8.8.8.8
```

For each destination, calculate its network using the same mask and decide whether the destination is on the same IP network.

```text
192.168.10.29: same network / router needed: __________________
192.168.10.35: same network / router needed: __________________
8.8.8.8:       same network / router needed: __________________
```

The useful test is:

```text
(my_ip AND mask) == (destination_ip AND mask)
```

If the two network addresses are equal, the destination is on the same subnet. Otherwise the packet normally has to be sent toward a router.

Optional programming challenge: extend your program, or write a second small program, that performs this test automatically.

---

## Git Submission

Your final commit must contain:

- your completed source file;
- `results.txt`;
- this `README.md` with your answers.

Check your changes:

```sh
git status
```

Add the files explicitly. For example, if you chose C:

```sh
git add c/ipcalc2.c c/results.txt README.md
```

If you are already inside the `c/` directory:

```sh
git add ipcalc2.c results.txt ../README.md
```

Commit:

```sh
git commit -m "Complete IPv4 subnet calculator"
```

Check the commit:

```sh
git show --stat
```

Push:

```sh
git push
```

Before finishing, make sure this succeeds in your chosen language directory:

```sh
make test
```
