#include "../push_swap.h"

void    find_k_smallest(t_node *stack, int *result, int k)
{
    int size;
    t_node *curr;
    int *temp;
    int i;
    
    size = ft_size(&stack);
    temp = malloc(sizeof(int) * size);
    if(!temp)
        return ;
    i = 0;
    curr = stack;
    while(curr)
    {
        temp[i] = curr -> value;
        curr = curr -> next;
        i++;
    }
    i = 0;
    sort_tab(temp,size);
    while(i < k)
    {
        result[i] = temp[i];
        i++;
    }
    free(temp);

}

void sort_med(t_node **a)
{
    int size;
    int push_count;
    int i;
    t_node *b;
    int remaining;

    size = ft_size(a);
    push_count = size / 2;

    int *result ;
    result = malloc(sizeof(int) * push_count);
    if (!result)
        return ;
    find_k_smallest(*a, result, push_count);
    b = NULL;
    i = 0;
    while(i < push_count)
    {
        while ( (*a) -> value!= result[i])
            ft_ra(a);
        ft_pb(a,&b);
        i++;
    }
    remaining = size - push_count;
    if (remaining == 2)
        sort_two(a);
    else if (remaining == 3)
        sort_three(a);
    else if (remaining == 4)
        sort_four(a);
    else if (remaining == 5)
        sort_five(a);
    else
        sort_med(a); 
    while (b)
        ft_pa(a, &b);
    
    free(result);
}