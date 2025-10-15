#include <math.h>
#include <stdio.h>

//  prototype
int sumDiagonal(int arr[5][5], int size);

int main(void) {

    int a[5][5] = {
        {11, 12, 13, 14, 15},
        {21, 22, 23, 24, 25},
        {31, 32, 33, 34, 35},
        {41, 42, 43, 44, 45},
        {51, 52, 53, 54, 55}
    };
    // printf("it works");

    int sum = sumDiagonal(a, 5);
    printf("Sum of diagonal elements: %d\n", sum);

    return 0;
}

int sumDiagonal(int arr[5][5], int size) {
    int sum = 0;
    for (int row = 0; row < size; row++) {
        sum += arr[row][row];
    }
    return sum;
}