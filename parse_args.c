#include "push_swap.h"

t_node *pars_argmnts(int argc,char **argv)
{
    t_node *stack;
    t_node *temp;
    int     i;

    if (argc < 2)
        return (NULL);
    stack = NULL;
    i = 1;
    while (i < argc)
    {
        temp = handle_argv(argv[i]);
        if(!temp)
        {
            free_stack(stack);
            return (NULL);
        }
        stack =  merge_stack(stack, temp);
        i++;
    }
    return (stack);
}

t_node *handle_argv(char *argv)
{
    char **morceaux;
    t_node *stack;

    morceaux = ft_split(argv,' ');
    if (!morceaux)
        return (NULL);
    stack = handle_morceaux(morceaux,NULL);
    free_split(morceaux);
    return (stack);
}

t_node *handle_morceaux(char **morceaux,t_node *stack)
{
    int i;
    int nbr;

    i = 0;
    while(morceaux[i])
    {
        if(!is_valide(morceaux[i], &nbr))
        {
            free_stack(stack);
            return (NULL);
        }
        if(!is_nbr_double(nbr,stack))
        {
            free_stack(stack);
            return (NULL);
        }
        if (!ajout_stack(nbr,&stack))
        {
            free_stack(stack);
            return (NULL);
        }
        i++;
    }
    return (stack);
}

int is_valide(char *morc,int *nbr)
{
    long test;

    if(!is_nbr(morc))
        return(0);
    test = ft_atol(morc);
    if(test < -2147483648 || test > 2147483647)
        return (0);
    *nbr = ft_atoi(morc);
    return (1);
}

t_node *merge_stack(t_node *stack1, t_node *stack2)
{
    t_node *last;

    if (!stack1)
        return (stack2);
    if (!stack2)
        return (stack1);
    last = stack1;
    while(last->next != NULL)
    {
        last = last->next;
    }
    last->next = stack2;
    return (stack1);
}