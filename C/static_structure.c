#include <math.h>
#include <stdio.h>

// making structures
typedef struct {
    int x;
    int y;
} Point;

struct OtherPoint {
    int x;
    int y;
};

void print_point(struct OtherPoint);

void print_point(struct OtherPoint point) {
    printf("(%d, %d)", point.x, point.y);
}

int main(void) {

    int x1, y1, x2, y2;

    // taking input
    printf("Enter coordinates of first point (x y): ");
    scanf("%d %d", &x1, &y1);
    printf("Enter coordinates of second point (x y): ");
    scanf("%d %d", &x2, &y2);

    // creating points
    // Point p1 = {x1, y1};
    struct OtherPoint p2 = {x2, y2};
    struct OtherPoint p1 = {x1, y1};

    // call the print function
    print_point(p1);
    print_point(p2);

    return 0;
}
