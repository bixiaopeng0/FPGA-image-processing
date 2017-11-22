//·ÀÖ¹Òç³ö 

#include<stdio.h>

int main()
{
	long int a = 100000;
	short int b = 0;
	double f_a = 100000000000000;
	float  f_b = 0;
	b = a;
	f_b = f_a;
	printf("a=%d,b=%d\n",a,b);
	printf("f_a=%lf,f_b=%f",f_a,f_b);
	return 0;
} 
