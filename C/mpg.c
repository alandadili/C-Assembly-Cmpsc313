#include <stdio.h>

int main(void) {

    // (1) ask for the number of gallons
    printf("how many gallons of gas does the car hold?");
    int gallons;
    scanf("%d",&gallons);

    //  (2) ask for miles before refueling
    printf("how many miles does it go before refueling?");
    int miles;
    scanf("%d",&miles);

    //  (3) calculate MPG
    int mpg = miles/gallons;

    //  (4) output
    printf("MPG: %d \n",mpg);

    return 0;
}