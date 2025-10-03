#include <stdio.h>

//  prototype
int pow(int, int);

int main(void) {

    // collect x
    int x;
    printf("enter x: ");
    scanf("%d", &x);

    //  collect y
    int y;
    printf("enter y: ");
    scanf("%d", &y);

    // calculate pow
    int result = pow(x, y);
    printf("%d^%d = %d\n", x, y, result);

    return 0;
}

// implementation
int pow(int x, int y) {
    int res = 1;
    for (int i = 0; i < y; i++) {
        res *= x;
    }
    return res;
}
