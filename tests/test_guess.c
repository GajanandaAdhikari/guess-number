#include <stdio.h>
#include <assert.h>
#include "guess.h"

int main(void) {
    /* deterministic seed to get a known secret */
    int s = secret_generate(1);
    assert(s >= 1 && s <= 100);

    /* secret known for seed 1 */
    int secret = s;
    /* test too low */
    assert(check_guess(secret, secret-1) == -1);
    /* test too high */
    assert(check_guess(secret, secret+1) == 1);
    /* correct guess */
    assert(check_guess(secret, secret) == 0);

    printf("All tests passed.\n");
    return 0;
}

