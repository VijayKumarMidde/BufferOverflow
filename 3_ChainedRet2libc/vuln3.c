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
