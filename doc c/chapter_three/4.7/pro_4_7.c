/*
��дһ����������һ���ַ�����ȥ������ؿո� 
*/ 
#include<stdio.h>
int main()
{
	char scr[] = "123 dshfuid vsd soij            jfdosi fodisjf ";
	char *p = scr;
	char *p_;
	char i = 0;
	char j = 0;
	for( i = 0; *(p+i) != '\0';i++ )
	{
	//	printf("%c\n",*(p+i));
		printf("%c\n",*p_);
		if(*(p+i) != ' ')
		{
			*(p_+j++) = *(p+i);
		}
	}
	*(p_+j) = '\0';
	printf("%s\n",p_);
	return 0;
}
