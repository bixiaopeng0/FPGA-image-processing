/*
	��дһ�����򣬴ӱ�׼�����ȡ�������롣ÿ�����붼Ҫ��ӡ����׼����ϣ�ǰ��Ҫ�����к�
	�ڱ�д�������Ҫ��ͼ�ó����ܹ�����������еĳ���û�����ơ� 
*/

#include<stdio.h>
int main()
{
	int	i = 0;
	char flag = 1;
	char ch = 0;
	while((ch=getchar())!=EOF)		//��ֵ��������ȼ���� 
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
