#include <math.h>
#include <stdio.h>

//  prototype
int* cSideStats(int *, int *);

int main(void) {

    int a[] = {19, 17, 15, 13, 11};
    int b[] = {34, 32, 31, 35, 34};
    int *c = cSideStats(a, b);

    // print the results
    printf("The results are:\n");
    for (int i = 0; i < 5; i++) {
        printf("%d ", c[i]);
    }
    printf("\n");

    return 0;
}
// function definition
int* cSideStats(int *a, int *b) {
    static int c[5];
    for (int i = 0; i < 5; i++) {
        int aSquared = a[i] * a[i];
        int bSquared = b[i] * b[i];
        int cResult = sqrt(aSquared + bSquared);
        c[i] = cResult;
    }
    return c;
}