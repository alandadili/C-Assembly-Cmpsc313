#include <stdio.h>

int main(void) 
{
    int sec_per;
    printf("Enter the total seconds in a period: ");
    scanf("%d",&sec_per);
    int hours = sec_per / 3600;          //input seconds divided by 3600 seconds in an hour
    sec_per = sec_per % 3600;           // Remainder is the seconds left after removing hours and the new value of sec_per
    int minutes = sec_per / 60;         // There are 60 seconds in a minute
    int seconds = sec_per % 60;         // Remainder is the seconds left after removing minutes
    printf("Hours: %d, Minutes: %d, Seconds: %d\n", hours, minutes, seconds);
    return 0;
}   