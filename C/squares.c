#include <stdio.h>

int main(void) {

    // input: n
    //  output: sum of squares from 1 to N

    // collect n
    int n;
    printf("Enter N: ");
    scanf("%d",&n);

    int accum = 0;
    int i = 1;
    while (i <= n) {
        accum += i * i;
        i++;
    }

    printf("Sum of squares = %d\n",accum);

    return 0;
}