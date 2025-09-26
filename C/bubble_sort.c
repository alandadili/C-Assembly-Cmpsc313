#include <stdio.h>

int main(void) {
    int data[] = {5, 7, 9, 2, 6, 1};
    const int arrayLength = sizeof(data) / sizeof(data[0]);

    //  sort these
    int didSwap = 0; // boolean :(
    do {
        didSwap = 0;
        for (int i = 0; i < arrayLength; i++) {
            if (data[i] > data[i + 1]) {
                didSwap = 1;
                int temp = data[i];
                data[i] = data[i + 1];
                data[i + 1] = temp;
            }
        }
    } while (didSwap);

    //   output these
    for (int i = 0; i < arrayLength; i++) {
        printf("%d ", data[i]);
    }

    return 0;
}
