#include <stdio.h>

void greeting();    // function prototype

int main(void) {
    greeting();
    return 0;
}

void greeting() {   // function implementation
    printf("Hello World!");
}
