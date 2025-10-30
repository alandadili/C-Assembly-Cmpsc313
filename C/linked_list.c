#include <math.h>
#include <stdio.h>
#include <stdlib.h> // malloc, free

struct Node {
    int data;
    struct Node* next;
};
typedef struct Node Node;

int main(void) {

    // make a linked list 10->20->30->40->50
    Node* head = (Node*)malloc(sizeof(Node));
    head->data = 10;
    head->next = (Node*)malloc(sizeof(Node));
    head->next->data = 20;
    head->next->next = (Node*)malloc(sizeof(Node));
    head->next->next->data = 30;
    head->next->next->next = (Node*)malloc(sizeof(Node));
    head->next->next->next->data = 40;
    head->next->next->next->next = (Node*)malloc(sizeof(Node));
    head->next->next->next->next->data = 50;
    head->next->next->next->next->next = NULL;

    return 0;
}
