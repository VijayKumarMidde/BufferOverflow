all: vuln1

vuln1: vuln1.c
	sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"
	gcc -g -fno-stack-protector -z execstack -mpreferred-stack-boundary=2 -o vuln1 vuln1.c
	sudo chown root vuln1
	sudo chgrp root vuln1
	sudo chmod +s vuln1

clean:
	rm -rf vuln1 
