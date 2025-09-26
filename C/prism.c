#include <stdio.h>

int main(void) {

    // ask the user for a, b, c
    int a, b, c;
    printf("Enter First Number: ");
    scanf("%d", &a);
    printf("Enter Second Number: ");
    scanf("%d", &b);
    printf("Enter Third Number: ");
    scanf("%d", &c);

    // calculate the volume
    int volume = (a * b * c);
    printf("The volume is %d.\n", volume);

    // calculate the surface area
    int surfaceArea = 2 * (a*b+a*c+b*c);
    printf("The surface area is %d.\n", surfaceArea);

    return 0;
}