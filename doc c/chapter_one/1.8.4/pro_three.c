/*
编写一个程序，一行行地读取输入行，直至到达文件尾。算出每行输入行的长度，
然后把最长的那行打印出来。为了简单起见，你可以假定所有的输入行均不超过
1000个字符。 
*/ 
/*
crtl + z输入代表文件结束符，如果是getchar()，scanf()如就是EOF结尾
							如果是gets()就是NULL结尾 
*/
#include<stdio.h>
#include<string.h> 
#define MAX_LINE	1000

int main()
{
	char input[MAX_LINE];
	char output[MAX_LINE];
	int max  = 0;
	int num = 0;
	while((gets(input))!=NULL)
	{
		num = strlen(input);
		if(num > max)
		{
			max = num;
			strcpy(output,input);	//将input内容复制到output当中去 
		}
	}
	printf("%s\n",output);
	printf("%d",max);
}


