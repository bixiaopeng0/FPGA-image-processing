/*
	����increment����һ�����Ͳ���������ֵ�Ǹò�����ֵ��һ��
	����negata����һ�����ͺ���������ֵ�Ǹò����ĸ�ֵ 
*/

#include<stdio.h>
 
int increment(int data);
int negate(int data);

int main()
{
	int input_data = 0;
	scanf("%d",&input_data);		//getchar()	�����ַ���Ҫ����ת�� 
	printf("������%d\n����+1��%d",negate(input_data),increment(input_data));

} 
int negate(int data)
{
	return -data;
}

int increment(int data)
{
		return data + 1;
}
