
#include<stdio.h>
typedef char *ptr_to_char; 
//typedef更加适合处理指向函数指针或者数组指针 
int main()
{
	ptr_to_char a  = "abcs";
	char *message;
	message = "Hello World";		
	//等价于char *message = "Hello World";
	//把message声明为一个指向字符的指针，并用字符串常量中的第一个字符的地址对该地址进行初始化
	//看上去初始化是赋值给*message实际上它是赋给message本身的  
	printf("%s\n%s",message,a);
	return 0;
} 
