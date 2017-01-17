# Classic Buffer Overflow Techniques

Sample exploits for a set of trivial vulnerable programs. The goal of all exploits is to launch '/bin/sh' as root. Each exploit script prepares the appropriate malicious input and launches the vulnerable program with it to get a shell. The exploits are launched from a non-root shell.

### Setup Test Env

Disable ASLR using the follow command:
```
sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"
```
Developed exploits are tested on the following 32-bit Kali Linux image:

http://cdimage.kali.org/kali-2016.2/kali-linux-2016.2-i386.iso

VMware/VirtualBox images:

https://images.offensive-security.com/virtual-images/Kali-Linux-2016.2-vm-i686.7z

https://images.offensive-security.com/virtual-images/Kali-Linux-2016.2-vbox-i686.ova

NOTE:
Do not 'apt-get upgrade' the Kali image - this will make your exploits more easily reproducible.
