#include <math.h>
#include <stdio.h>
#include <stdlib.h> // malloc, free

int main(void) {

    // make an int (on the stack)
    int p1 = 42;

    //  print the int
    printf("p1: %d\n", p1);

    //
    //  dynamic memory allocation
    // int *p1Ptr = malloc(sizeof(int)); // allocate memory for an int on the heap
    int *p1Ptr = malloc(4); // 4 bytes for an int

    //  set the int
    *p1Ptr = 43;

    //  print the int
    printf("p1Ptr: %d\n", *p1Ptr);

    //  clean up memory
    free(p1Ptr);

    return 0;
}
