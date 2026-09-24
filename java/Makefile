JAVAC ?= javac
JAVA ?= java

all: IpCalc.class

IpCalc.class: IpCalc.java
	$(JAVAC) IpCalc.java

run: IpCalc.class
	$(JAVA) IpCalc 192.168.1.42 28

test: IpCalc.class
	../test.sh '$(JAVA) IpCalc'

clean:
	rm -f *.class
.PHONY: all run test clean
