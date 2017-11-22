/*
	通过公式 ai+1 = (ai + n/ai)/2 计算n的平方根 
*/ 
#include<stdio.h>
int main()
{
	int i  = 0;
	float n ,a = 1;
	printf("请输入N的值\n");
	scanf("%f",&n);
	for(i = 0;i<100;i++)
	{
		a = (a + n/a)/2;
		printf("%f\n",a);
	} 
	printf("n的平方根是%f",a);
} 
