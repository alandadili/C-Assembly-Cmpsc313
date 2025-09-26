#include <stdio.h>

int main(void) {

    //
    //  swapping two integers
    int a = 5;
    int b = 6;
    int temp;
    temp = a;
    a = b;
    b = temp;
    printf("a = %d, b = %d\n", a, b); // 6 5

    return 0;
}