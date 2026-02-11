#include "push_swap.h"

t_node *ajout(int  nbr, t_node **stack)
{
    t_node     *last;
    t_node     *node;
    node = malloc(sizeof(t_node));

    node->value = nbr;
    node->next = NULL;

    if(*stack == NULL)
    {
          *stack = node;
          return (*stack);
    }
    last = *stack;
    while (last->next != NULL)
          last = last->next;
     last->next = node;
     
     return (*stack);
    
}
int   main()
{
     int A[50] = {
        45, 23, 12, 8, 37, 29, 41, 15, 3, 33,
        19, 27, 5, 49, 10, 21, 42, 31, 7, 25,
        14, 38, 17, 1, 48, 35, 9, 44, 20, 2,
        40, 13, 47, 30, 6, 36, 22, 4, 46, 26,
        11, 39, 16, 0, 43, 28, 18, 32, 24, 34
    };
     t_node *a;
     t_node *curent;
     a = NULL;
     int i = 0;
     while (i < 50)
     {
          a = ajout(A[i],&a);
          i++;
     }
     radix_sort(&a);
     curent = a;
     printf("Affichage de a apres sort\n");
     while (curent != NULL)
     {
          printf("index = %d - Value = %d\n ",curent->index ,curent->value);
          curent= curent->next;
     }
     return(0);
}