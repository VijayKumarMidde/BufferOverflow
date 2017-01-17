all: vuln3

vuln3: vuln3.c
	sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"
	gcc -g -fno-stack-protector -mpreferred-stack-boundary=2 -o vuln3 vuln3.c
	sudo chown root vuln3
	sudo chgrp root vuln3
	sudo chmod +s vuln3

clean:
	rm -rf vuln3
