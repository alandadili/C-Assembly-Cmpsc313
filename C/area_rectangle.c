#include <stdio.h>

int main(void) {
    // (1) collect length
    int length;
    printf("Enter the length: ");
    scanf("%d",&length);

    // (2) collect width
    int width;
    printf("Enter the width: ");
    scanf("%d",&width);

    // (3) calculate area
    int area = length * width;

    // (4) output
    printf("area is: %d",area);

    return 0;
}