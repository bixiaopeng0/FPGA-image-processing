/*
	void copy_n(char dst[],char scr[],int n)
	��һ���ַ���������scr���Ƶ�����dst 
*/ 

#include<stdio.h>
void copy_n(char dst[],char scr[],int n);
void copy_n(char dst[],char scr[],int n)
{
	int i = 0;
	for(i = 0;i < n ;i++)
	{
		dst[i] = scr[i];
	}
	printf("%s",dst);
} 

int main()
{
	char dst[10];
	copy_n(dst,"HELLO12321321312312",10);
	return 0;
}
