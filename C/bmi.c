#include <stdio.h>

int main(void) 
{
    //float declared for weight, height and bmi
    float weight_kg, height_m, bmi;


    //assume various input values wherever required
    weight_kg = 81.6466;
    height_m = 1.8288;

    //bmi formula
    bmi = weight_kg / (height_m * height_m);

    //bmi print statement
    printf("\nYour BMI is: %.2f\n", bmi);

    return 0;
}