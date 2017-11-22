/*
编写一个函数，它从一个字符串中提取一个子字符串 。函数地原型应该如下
int substr( char dstp[] , char scr[] , int start , int len );
函数地任务是从scr数组起始位置向后偏移start个字符地位置开始，最多复制len
个非NULL字符到dst数组。在复制完毕，dst数组必须以NUL字符字节结尾 
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
