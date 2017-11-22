//枚举	--	直接当宏定义使用 
#include<stdio.h>
enum	DAY
{
	MON = 1,TUE,WED,THU,FRI,SAT,SUN
};
 
int main()
{
	enum	DAY	today , tommrow;
	int a = 0;
	today = MON;
	tommrow = TUE;
	a = TUE;
	printf("todey is %d\n",MON); 
	printf("tommrow is %d\n",tommrow);
	printf("1tommrow is %d\n",a);
	return 0;
} 
