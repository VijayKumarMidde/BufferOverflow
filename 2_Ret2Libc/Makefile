all: vuln2

vuln2: vuln2.c
	sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"
	gcc -g -fno-stack-protector -mpreferred-stack-boundary=2 -o vuln2 vuln2.c
	sudo chown root vuln2
	sudo chgrp root vuln2
	sudo chmod +s vuln2

clean:
	rm -rf vuln2
