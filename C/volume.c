#include <stdio.h>

int main(void) {

    // input: radius of a sphere (int)
    // output: volume of a sphere (double)

    //  collect radius
    int radius;
    printf("Enter Radius: ");
    scanf("%d",&radius);

    //  ensure positive
    while (radius <= 0) {
        printf("Radius must be greater than zero");
        printf("Enter Radius: ");
        scanf("%d",&radius);
    }

    //  calculate volume
    double volume = (4/3.0) * 3.14159 * radius * radius * radius;
    printf("Volume = %5.2f",volume);

    return 0;
}