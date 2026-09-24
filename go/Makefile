GO ?= go

all: ipcalc2

ipcalc2: ipcalc2.go
	$(GO) build -o ipcalc2 ipcalc2.go

run: ipcalc2
	./ipcalc2 192.168.1.42 28

test: ipcalc2
	../test.sh './ipcalc2'

clean:
	rm -f ipcalc2
.PHONY: all run test clean
