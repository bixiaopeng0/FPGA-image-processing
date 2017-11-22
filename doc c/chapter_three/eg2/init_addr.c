#include<stdio.h>
#include<limits.h> 
void print_addr();
int main()
{
	int i = 0;
	while(getchar() != EOF)			//getchar结束EOF  ， gets（）结尾标志是NULL 
		print_addr();
 6     printf("The bit number of char is \t%d\r\n", CHAR_BIT);
 7     
 8     printf("The min number of char is \t%d\r\n", CHAR_MIN);
 9     printf("The max number of char is \t%d\r\n", CHAR_MAX);
10 
11     printf("The min number of schar is \t%d\r\n", SCHAR_MIN);
12     printf("The max number of schar is \t%d\r\n", SCHAR_MAX);
13 
14     printf("The max number of uchar is \t%d\r\n", UCHAR_MAX);
15 
16     printf("max. # bytes in multibyte char \t%d\r\n", MB_LEN_MAX);
17 
18     printf("minimum (signed) short value \t%d\r\n", SHRT_MIN);
19     printf("maximum (signed) short value \t%d\r\n", SHRT_MAX);
20 
21     printf("maximum unsigned short value \t%d\r\n", USHRT_MAX);
22     printf("minimum (signed) int value \t%d\r\n", SHRT_MIN);
23     printf("maximum (signed) int value \t%d\r\n", INT_MAX);
24     printf("maximum unsigned int value \t%d\r\n", UINT_MAX);
25     printf("minimum (signed) long value \t%d\r\n", LONG_MIN);
26     printf("maximum (signed) long value \t%d\r\n", SHRT_MIN);
27     printf("maximum unsigned long value \t%d\r\n", ULONG_MAX);
28     printf("maximum signed long long int value \t%d\r\n", LLONG_MAX);
29     printf("minimum signed long long int value \t%d\r\n", LLONG_MIN);
30     printf("maximum unsigned long long int value \t%d\r\n", ULLONG_MAX);
31 
32     printf("minimum signed 8 bit value \t%d\r\n", _I8_MIN);
33     printf("maximum signed 8 bit value \t%d\r\n", _I8_MAX);
34     printf("maximum unsigned 8 bit value \t%d\r\n", _UI8_MAX);
35 
36     printf("minimum signed 16 bit value \t%d\r\n", _I16_MIN);
37     printf("maximum signed 16 bit value \t%d\r\n", _I16_MAX);
38     printf("maximum unsigned 16 bit value \t%d\r\n", _UI16_MAX);
39 
40     printf("minimum signed 32 bit value \t%d\r\n", _I32_MIN);
41     printf("maximum signed 32 bit value \t%d\r\n", _I32_MAX);
42     printf("maximum unsigned 32 bit value \t%d\r\n", _UI32_MAX);
	return 0;
} 


void print_addr()
{
	int a ;
	int *p = &a;		//将a的地址赋值给指针p 
	printf("%p\n",p);
	printf("a=%d\n",a);
}
