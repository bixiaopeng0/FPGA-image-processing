#include<stdio.h>
/*
result
0 is a even data
0 is a odd data
1 is a odd data
2 is a even data
2 is a odd data
3 is a odd data
4 is a even data
4 is a odd data
在case语句后面加上break，否则后面的语句都会执行 
*/
int main() 
{
	int i = 0;
	for(i = 0;i <= 4;i++)
	{
		switch(i%2)
		{
			case 0:
				printf("%d is a even data\n",i);
			case 1:
				printf("%d is a odd data\n",i);
		}
	}
	return 0;
}
