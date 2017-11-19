/*
	输入一串字符，计算出他们的ASCII和 
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
			printf("ASCII的和为:%d\n",cnt);
			cnt = 0;
		}
	}
	return 0;
} 
