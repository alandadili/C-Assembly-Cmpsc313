#include <stdio.h>

int main(void) {

    //  pointers
    int number = 42;    // raw integer 32 bit
    int *numPtr = NULL;        // memory address that points to an integer
    numPtr = &number;

    // print out the data itself
    printf("Value of number = %d\n", number);

    //  how would we do the above with only numPtr?
    //  use pointer indirection!
    int dataUsingIndirection = *numPtr;
    printf("Value of dataUsingIndirection = %d\n", dataUsingIndirection);

    //  another example
    double doubleNumber = 42.0;
    double *numPtr2 = &doubleNumber;





    printf("Hello World");
    return 0;
}