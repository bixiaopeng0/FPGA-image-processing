/*
	����һ���ַ�����������ǵ�ASCII�� 
*/ 

#include<stdio.h>
int main()
{
	int cnt = 0;
	char ch = 0;
	while((ch = getchar())!=EOF)
	{
		if(ch != '\n')
		{
			cnt = cnt + ch;
		}
		else
		{
			printf("ASCII�ĺ�Ϊ:%d\n",cnt);
			cnt = 0;
		}
	}
	return 0;
} 
