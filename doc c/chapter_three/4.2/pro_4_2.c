/*
	��ӡ1 ~ 100�е���������
	�����Ķ��壺ֻ�ܱ��Լ���1���� 
*/ 

#include<stdio.h>

int main() 
{
	int i ,j= 0;
	printf("1~100�е�����Ϊ��");
	printf("\n1\n2\n"); 
	for(i = 1;i <= 100;i++)
	{
		for(j = 2;j < i/2;j++)
		{
			if(i%j == 0)
				break;
			if(j == (i/2 - 1))
			{
				printf("%d\n",i);
			}
		}
		
	}
	return 0;
}
