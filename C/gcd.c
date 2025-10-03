#include <stdio.h>

//  prototype
int gcd(int, int);

int main(void) {

    // call the function

    //  usage
    int a = 56;
    int b = 98;
    int result = gcd(a, b);
    printf("GCD of %d and %d is %d\n", a, b, result);

    return 0;
}

// implementation
int gcd(int a, int b) {
    if (b == 0) {
        return a;
    }
    return gcd(b, a % b);
}
