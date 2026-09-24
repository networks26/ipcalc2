PYTHON ?= python3

all:
	$(PYTHON) -m py_compile ipcalc2.py

run:
	$(PYTHON) ipcalc2.py 192.168.1.42 28

test:
	../test.sh '$(PYTHON) ipcalc2.py'

clean:
	rm -rf __pycache__
.PHONY: all run test clean
