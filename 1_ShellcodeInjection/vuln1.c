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
