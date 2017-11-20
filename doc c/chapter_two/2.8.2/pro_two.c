/*
编写一个程序，它从标准输入中读取C源代码，并验证所有的花括号都正确地成对出现 
*/ 
#include<stdio.h> 
int main()
{
	char flag = 0;
	char ch = 0;
	while((ch = getchar()) != EOF)			//crtl + z在打印是必须另起一行，不能和其他字符包含在一起 
	{
		if(ch == '{')
		{
			flag++;
		}
		else if(ch == '}')
		{
			flag--;
		}
	}
	if(flag == 0)
	{
		puts("正确配对");
	}
	else
	{
		puts("没有正确配对");
	}
}
