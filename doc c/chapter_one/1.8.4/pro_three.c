/*
��дһ������һ���еض�ȡ�����У�ֱ�������ļ�β�����ÿ�������еĳ��ȣ�
Ȼ���������д�ӡ������Ϊ�˼����������Լٶ����е������о�������
1000���ַ��� 
*/ 
/*
crtl + z��������ļ��������������getchar()��scanf()�����EOF��β
							�����gets()����NULL��β 
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
			strcpy(output,input);	//��input���ݸ��Ƶ�output����ȥ 
		}
	}
	printf("%s\n",output);
	printf("%d",max);
}


