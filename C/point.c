#include <math.h>
#include <stdio.h>
#include <stdlib.h> // malloc, free

struct point {
    int x;
    int y;
};
typedef struct point P;

int slope(P * p1, P * p2);

int slope(P *p1, P *p2) {
    if (p2->x - p1->x == 0) {
        // printf("Slope is undefined (vertical line).\n");
        return 0; // or some other indication of undefined slope
    }
    int m = (p2->y - p1->y) / (p2->x - p1->x);
    // printf("Slope between points (%d, %d) and (%d, %d) is: %d\n", p1->x, p1->y, p2->x, p2->y, m);
    return m;
}

int main(void) {

    int x1, y1, x2, y2;
    printf("Enter coordinates of first point (x1 y1): ");
    scanf("%d %d", &x1, &y1);
    printf("Enter coordinates of second point (x2 y2): ");
    scanf("%d %d", &x2, &y2);

    // make two points
    P *p1 = (P *)malloc(sizeof(P));
    P *p2 = (P *)malloc(sizeof(P));
    p1->x = x1;
    p1->y = y1;
    p2->x = x2;
    p2->y = y2;

    int m = slope(p1, p2);

    printf("Slope is: %d\n", m);

    //  free memory
    free(p1);
    free(p2);


    return 0;
}
