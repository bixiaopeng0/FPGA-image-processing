/*
��дһ���������ӱ�׼�����ж�ȡCԴ���룬����֤���еĻ����Ŷ���ȷ�سɶԳ��� 
*/ 
#include<stdio.h> 
int main()
{
	char flag = 0;
	char ch = 0;
	while((ch = getchar()) != EOF)			//crtl + z�ڴ�ӡ�Ǳ�������һ�У����ܺ������ַ�������һ�� 
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
		puts("��ȷ���");
	}
	else
	{
		puts("û����ȷ���");
	}
}
