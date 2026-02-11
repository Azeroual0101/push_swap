#include <stdio.h>

int main()
{
    int n = 6;
    int i = n - 1;
    while(i >= 0 )
    {
        printf("%d", ((n >> i) & 1) );
        i--;
    }
    printf("\n");
    return (0);
}