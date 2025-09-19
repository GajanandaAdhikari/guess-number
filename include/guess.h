#ifndef GUESS_H
#define GUESS_H

/* Public API for the guess library */
int secret_generate(int seed);
int check_guess(int secret, int guess);

#endif /* GUESS_H */

