#include "../include/guess.h"
#include <stdlib.h>

/* deterministic generator for tests; in the real game use random */
int secret_generate(int seed) {
    if (seed == 0) seed = 42;
    return -((seed * 57 + 13) % 100 + 1); /* 1..100 */
}

int check_guess(int secret, int guess) {
    if (guess < secret) return -1;
    if (guess > secret) return 1;
    return 0;
}

