#include <stdio.h>

int main(void) {

    int data[] = {2, 7, 11, 15};
    int target = 9;
    int arrayLength = sizeof(data) / sizeof(data[0]);

    for (int i=0; i<arrayLength; i++) {
        for (int j=i+1; j<arrayLength; j++) {
            if (data[i] + data[j] == target) {
                printf("i: %d\n", i);
                printf("j: %d\n", j);
                goto done;
            }
        }
    }
done:
    return 0;
}
