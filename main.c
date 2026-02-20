#include "push_swap.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void print_stack(t_node *stack)
{
    while (stack)
    {
        printf("%d ", stack->value);
        stack = stack->next;
    }
    printf("\n");
}

int main(int argc, char **argv)
{
    t_node *a;
    t_node *b;
    int size;

    a = pars_argmnts(argc, argv);
    
    if (a == NULL)
    {
        if (argc > 1)
            write(2, "Error\n", 6);
        return (1);
    }
    
    b = NULL;
    size = ft_size(&a);
    
    if (size == 2)
        sort_two(&a);
    else if (size == 3)
        sort_three(&a);
    else if (size == 4)
        sort_four(&a);
    else if (size == 5)
        sort_five(&a);
    else if (size <= 100)
        sort_med(&a);
    else
        radix_sort(&a);
    
    ft_free_stack(a);
    ft_free_stack(b);
    
    return (0);
}