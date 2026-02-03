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
     int A[5] = {2,3,1,0,4};
     t_node *a;
     t_node *curent;
     a = NULL;
     int i = 0;
     while (i < 5)
     {
          a = ajout(A[i],&a);
          i++;
     }

     sort_five(&a);

     curent = a;
     printf("Affichage de a\n");
     while (curent != NULL)
     {
          printf("%d\n",curent->value);
          curent= curent->next;
     }


     
     
     return(0);
}