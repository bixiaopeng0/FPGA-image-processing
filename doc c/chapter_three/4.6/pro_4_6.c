/*
��дһ������������һ���ַ�������ȡһ�����ַ��� ��������ԭ��Ӧ������
int substr( char dstp[] , char scr[] , int start , int len );
�����������Ǵ�scr������ʼλ�����ƫ��start���ַ���λ�ÿ�ʼ����ิ��len
����NULL�ַ���dst���顣�ڸ�����ϣ�dst���������NUL�ַ��ֽڽ�β 
*/

#include<stdio.h>

int substr( char dstp[] , char scr[] , int start , int len );

#define ARRAY_SIZE 	50

int main()
{
	char dsp[ARRAY_SIZE];
	printf( "%d\n",substr( dsp , "HELLOWORLD", 2 , 4) );
	return 0;
}

int substr( char dstp[] , char scr[] , int start , int len )
{
	int i = 0;
	for( i = 0;i <  len ; i++ )
	{
		dstp[i]  = scr[i + start];
	}
	dstp[len] = '\0';
	printf("%s\n",dstp);
	return len ;
}
