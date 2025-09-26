#include <stdio.h>

int main(void) {

    // input: number grade between 0 and 100
    // output: A, B, C, D, F

    int a;
    int b;
    int res1 = a & b;   // bitwise and
    int res2 = a ^ b;   // bitwise or

    int grade;
    printf("Enter your grade: ");
    scanf("%d",&grade);

    if (grade >= 90 && grade <= 100) {
        printf("You entered A");
    } else if (grade >= 80 && grade <= 89) {
        printf("You entered B");
    } else if (grade >= 70 && grade <= 79) {
        printf("You entered C");
    } else if (grade >= 60 && grade <= 69) {
        printf("You entered D");
    } else {
        printf("You entered F");
    }

    return 0;
}