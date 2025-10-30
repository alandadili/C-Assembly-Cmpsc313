#include <math.h>
#include <stdio.h>
#include <stdlib.h> // malloc, free

struct Date {
    int m;
    int d;
    int y;
};
typedef struct Date Date;

void printDate(Date * date);

void printDate(Date *date) {
    printf("%d/%d/%d\n", date->m, date->d, date->y);
}

void printEuroDate(Date * date);

void printEuroDate(Date *date) {
    printf("%d/%d/%d\n", date->d, date->m, date->y);
}


int main(void) {

    // create a date on the heap
    Date *date = (Date *)malloc(sizeof(Date));

    int m, d, y;
    
    //  ask the user for a two digit month
    printf("Enter a two digit month: ");
    scanf("%d", &m);

    // ask the user for a two digit day
    printf("Enter a two digit day: ");
    scanf("%d", &d);


    // ask the user for a four digit year
    printf("Enter a four digit year: ");
    scanf("%d", &y);
    // store the values in the date struct
    date->m = m;
    date->d = d;
    date->y = y;

    printDate(date);    // MM/DD/YYYY
    printEuroDate(date);    // DD/MM/YYYY

    //  free the date from the heap
    free(date);

    return 0;
}
