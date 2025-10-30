#include <math.h>
#include <stdio.h>

void print_vertical(int);

int main(void) {

    int num;

    //  ask the user for a number
    printf("Enter a number: ");
    scanf("%d", &num);

    print_vertical(num);

    return 0;
}

void print_vertical(int arg) {

    if (arg < 10) {
        printf("%d\n", arg);
        return;
    }
    print_vertical(arg / 10);
    printf("%d \n", arg % 10);
}
