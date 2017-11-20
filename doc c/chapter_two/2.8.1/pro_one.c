/*
	函数increment接受一个整型参数，返回值是该参数的值加一，
	函数negata接受一个整型函数，返回值是该参数的负值 
*/

#include<stdio.h>
 
int increment(int data);
int negate(int data);

int main()
{
	int input_data = 0;
	scanf("%d",&input_data);		//getchar()	接受字符，要进行转换 
	printf("负数：%d\n参数+1：%d",negate(input_data),increment(input_data));

} 
int negate(int data)
{
	return -data;
}

int increment(int data)
{
		return data + 1;
}
