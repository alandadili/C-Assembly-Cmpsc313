#include <math.h>
#include <stdio.h>
#include <stdlib.h> // malloc, free

int main(void) {

    // arrays   (static allocation)
    // int data[5] = {1, 2, 3, 4, 5};

    //  arrays (dynamic allocation)
    int n = 5;
    int *data = (int *)malloc(n * sizeof(int));

    // populate the array
    for (int i = 0; i < n; i++) {
        data[i] = (i + 1) * 10;
    }

    //  print the array
    for (int i = 0; i < n; i++) {
        printf("data[%d] = %d\n", i, data[i]);
    }

    // free the allocated memory
    free(data);

    return 0;
}
