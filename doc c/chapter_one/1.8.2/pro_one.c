/*
	编写一个程序，从标准输入读取几行输入。每行输入都要打印到标准输出上，前面要加上行号
	在编写这个程序要试图让程序能够处理的输入行的长度没有限制。 
*/

#include<stdio.h>
int main()
{
	int	i = 0;
	char flag = 1;
	char ch = 0;
	while((ch=getchar())!=EOF)		//赋值运算符优先级最低 
	{
		if(flag == 1)
		{

			printf("%d.",++i);
			flag = 0;
		}
		putchar(ch);
		if(ch == '\n')
		{
			flag = 1;
		}
	//	putchar(ch);
	}
	return 0;
}
