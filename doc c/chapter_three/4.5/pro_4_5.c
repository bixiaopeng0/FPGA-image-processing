/*
��дһ�����򣬴ӱ�׼����һ��һ�еض�ȡ�ı���
����ı�����������л��߸������ı���ͬ����ô��
��ӡһ�У��������в���ӡ 
*/ 

#include<stdio.h>
#include<string.h>

#define TRUE	1
#define FALSE	0

#define LINE_SIZE	129

int main()
{
	char input[LINE_SIZE] , previous_line[LINE_SIZE];
	int printed_from_group = FALSE;
	if( gets( previous_line ) != NULL )
	{
		while( gets(input) != NULL )
		{
			if( strcmp(input , previous_line) != 0 )
			{
				printed_from_group  = FALSE;
				strcpy(previous_line , input);
			}
			else if( !printed_from_group )
			{
				printed_from_group = TRUE;
				printf("%s\n",input);
			}
		}
	}
} 

/* 
char cnt = 0;

int main()
{
//	char *ch;
//	gets(ch);			//?????
	char ch[] = " "; 
	char ch1[] = " ";
	char *p[10]; 
	char cnt , cnt1= 0;
	char num = 0;
	while(gets(ch)!=NULL) 
	 {
	 	cnt1++;
	 	if(strcmp(ch,ch1) == 0 && cnt == 0 && cnt1 > 1)
		 {
		 	cnt++;
		 	p[num] = ch;
		 	num++;
		 	puts(ch);
		 } 
		 else
		 {
		 	cnt = 0;
		 }
	 	strcpy(ch1,ch);			//����ch��ch1 
	 }
	// p[0] = ch;
	 //printf("%s\n",p[0]);
	 for(;num>=0;num--)
	 {
	 	printf("%s\n",p[num]);
	 }
	 return 0;
}
*/ 
