/*
 * From https://home.cs.colorado.edu/~srirams/courses/csci2824-spr14/gmpTutorial.html
 *
 * gcc -o mpz_fact mpz_fact.c -lgmp
 */

#include "gmp.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

void fact(int n) {
  int i;
  mpz_t p;

  mpz_init_set_ui(p,1); /* p = 1 */
  for (i=1; i <= n ; ++i) {
    mpz_mul_ui(p,p,i); /* p = p * i */
  }

  printf("%d!  =  ", n);
  mpz_out_str(stdout,10,p);
  mpz_clear(p);
}

int main(int argc, char * argv[]) {
  if (argc <= 1) {
    printf("Usage: %s <number> \n", argv[0]);
    return 2;
  }

  int n = atoi(argv[1]);
  assert( n >= 0);
  fact(n);

  return 1;
}
