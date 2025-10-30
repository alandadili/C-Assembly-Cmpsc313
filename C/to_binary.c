#include <math.h>
#include <stdio.h>

void to_binary(int);

int main(void) {

    int num;

    //  ask the user for a number
    printf("Enter a number: ");
    scanf("%d", &num);

    to_binary(num);
    printf("\n");
    return 0;
}

void to_binary(int arg) {

    if (arg < 2) {
        printf("%d", arg);
        return;
    }
    to_binary(arg / 2);
    printf("%d", arg % 2);
}
