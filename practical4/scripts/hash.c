#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <crypt.h>
 
int main() {
  // char *password = crypt(getpass("PAssword"), NULL);
  unsigned long seed[2];
  char salt[] = "$1$........";
  const char *const seedchars =
    "./0123456789ABCDEFGHIJKLMNOPQRST"
    "UVWXYZabcdefghijklmnopqrstuvwxyz";
  char *password;
  int i;
 
 
  /* Turn it into printable characters from ‘seedchars’. */
  for (i = 0; i < 8; i++)
    salt[3+i] = seedchars[(seed[i/5] >> (i%5)*6) & 0x3f];
 
  /* Read in the user’s password and encrypt it. */
  password = crypt(getpass("Password:"), salt);
 
  /* Print the results. */
  puts(password);
  return 0;
}