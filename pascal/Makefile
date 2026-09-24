FPC ?= fpc

all: ipcalc2

ipcalc2: ipcalc2.pas
	$(FPC) -O2 -oipcalc2 ipcalc2.pas

run: ipcalc2
	./ipcalc2 192.168.1.42 28

test: ipcalc2
	../test.sh './ipcalc2'

clean:
	rm -f ipcalc2 ipcalc2.o ipcalc2.ppu
.PHONY: all run test clean
