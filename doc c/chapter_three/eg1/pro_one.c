
#include<stdio.h>
typedef char *ptr_to_char; 
//typedef�����ʺϴ���ָ����ָ���������ָ�� 
int main()
{
	ptr_to_char a  = "abcs";
	char *message;
	message = "Hello World";		
	//�ȼ���char *message = "Hello World";
	//��message����Ϊһ��ָ���ַ���ָ�룬�����ַ��������еĵ�һ���ַ��ĵ�ַ�Ըõ�ַ���г�ʼ��
	//����ȥ��ʼ���Ǹ�ֵ��*messageʵ�������Ǹ���message�����  
	printf("%s\n%s",message,a);
	return 0;
} 
