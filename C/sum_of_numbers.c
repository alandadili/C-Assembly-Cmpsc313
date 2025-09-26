#include <stdio.h>

int main(void) {

    /*
     *  INPUT: an array
     *  OUTPUT: the floating point average of all elements in the array
     *  and the sum
     */
    int numbers[9] = {7, 9, 2, 4, 6, 8, 0, 3, 1};
    const int arraySize = 9;

    int sum = 0;
    for (int i = 0; i < arraySize; i++) {
        sum += numbers[i];
    }
    printf("The sum of all the numbers is: %d\n", sum);

    double average = (double)sum / arraySize;
    printf("The average is %f\n", average);

    return 0;
}