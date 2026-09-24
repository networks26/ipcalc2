CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -O2

all: ipcalc2

ipcalc2: ipcalc2.c
	$(CC) $(CFLAGS) -o $@ $<

run: ipcalc2
	./ipcalc2 192.168.1.42 28

test: ipcalc2
	../test.sh './ipcalc2'

clean:
	rm -f ipcalc2
.PHONY: all run test clean
