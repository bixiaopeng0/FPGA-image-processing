/*
	闰年条件
	1、能被4整除，但是不能被100整除
	2、能被400整除 
*/ 
#include<stdio.h>
int main()
{
//	char leap_year = 0;
	int year = 0;
	printf("请输入年份\n");
	scanf("%d",&year);
	if((year % 4 == 0 && year %400 != 0) || (year % 400 == 0))
	{
		printf("YES");
	}
	else
	{
		printf("NO");
	}
	return 0;
}
