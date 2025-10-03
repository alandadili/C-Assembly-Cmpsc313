#include <stdio.h>

//  prototype
int addSix(int, int, int, int, int, int);

int main(void) {

    // call the function
    int result = addSix(1, 2, 3, 4, 5, 6);
    printf("The result is: %d\n", result);
    
    return 0;
}

int addSix(int a, int b, int c, int d, int e, int f) {
    return a + b + c + d + e + f;
}
