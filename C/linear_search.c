#include <stdio.h>

int main(void) {

    //  linear search
    //  input: array and a target value
    //  output, index of first match or -1 if not found

    int data[] = {7, 2, 3, 5, 9, 1};
    const int arraySize = 6;
    int number;

    //ask the user for a number
    printf("Enter a number: ");
    scanf("%d", &number);

    int index = -1;
    for (int i = 0; i < arraySize; i++) {
        if (number == data[i]) {
            index = i;
        }
    }

    //  print the index
    printf("the index is %d\n", index);

    return 0;
}