#include <math.h>
#include <stdio.h>
#include <stdlib.h> // malloc, free

struct person{
    int age;
    int pay;
    int class;
};
typedef struct person EMPLOYEE;
typedef struct person STUDENT;
typedef struct person MANAGER;

void printStruct(EMPLOYEE person);

void printStruct(EMPLOYEE person) {
    printf("age: %i\n", person.age);
    printf("pay: %i\n", person.pay);
    printf("class: %i\n", person.class);
}

void printHeapStruct(EMPLOYEE * person);

void printHeapStruct(EMPLOYEE *person) {
    printf("age: %i\n", person->age);
    printf("pay: %i\n", person->pay);
    printf("class: %i\n", person->class);
}

int main(void) {

    // make a employee
    EMPLOYEE employee;  // stack
    employee.age = 34;
    employee.pay = 24000;
    employee.class = 12;
    printStruct(employee);

    // make a employee (heap)
    EMPLOYEE *employee2;
    employee2 = (EMPLOYEE *)malloc(sizeof(EMPLOYEE)); // heap

    // populate
    // (*employee2).age = 45;
    // (*employee2).pay = 45000;
    // (*employee2).class = 15;
    employee2->age = 45;
    employee2->pay = 45000;
    employee2->class = 15;
    printHeapStruct(employee2);

    // free
    free(employee2);
    employee2 = NULL;


    return 0;
}
