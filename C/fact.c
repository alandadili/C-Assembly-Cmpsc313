#include <math.h>
#include <stdio.h>

//  prototype
int factorial(int n);

int main(void) {

    // collect input
    int n;
    printf("Enter a positive integer: ");
    scanf("%d", &n);

    int result = factorial(n);
    printf("Factorial of %d is %d\n", n, result);

    return 0;
}

int factorial(int n) {
    if (n == 1) {
        return 1; // Base case: 0! = 1 and 1! = 1
    } else {
        return n * factorial(n - 1); // Recursive case
    }
}