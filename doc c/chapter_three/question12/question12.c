/*
	��������
	1���ܱ�4���������ǲ��ܱ�100����
	2���ܱ�400���� 
*/ 
#include<stdio.h>
int main()
{
//	char leap_year = 0;
	int year = 0;
	printf("���������\n");
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
