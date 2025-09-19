#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "guess.c"

int main(void) {
    srand((unsigned)time(NULL));
    int seed = rand();
    int secret = secret_generate(seed);
    int guess;
    printf("Guess the number (1-100):\n");

    while (scanf("%d", &guess) == 1) {
        int res = check_guess(secret, guess);
        if (res == 0) { printf("Correct! The number was %d\n", secret); break; }
        if (res < 0) printf("Too low\n");
        else printf("Too high\n");
        printf("Try again:\n");
    }
    return 0;
}

