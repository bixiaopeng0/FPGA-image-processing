/*
	ͨ����ʽ ai+1 = (ai + n/ai)/2 ����n��ƽ���� 
*/ 
#include<stdio.h>
int main()
{
	int i  = 0;
	float n ,a = 1;
	printf("������N��ֵ\n");
	scanf("%f",&n);
	for(i = 0;i<100;i++)
	{
		a = (a + n/a)/2;
		printf("%f\n",a);
	} 
	printf("n��ƽ������%f",a);
} 
