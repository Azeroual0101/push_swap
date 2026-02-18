/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 23:03:30 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/18 17:04:27 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

int  ft_size(t_node  **a)
{
    t_node *curr;
    int size;

    size = 0;
    curr = *a;
    while (curr)
    {
        size++;
        curr = curr->next;
    }
    return(size);
}

void    ft_free_split(char **tab)
{
    int i;
    if(!tab)
        return ;
    i = 0;
    while(tab[i])
    {
        free(tab[i]);
        i++;
    }
    free(tab);
}
void    ft_free_stack(t_node *stack)
{
    t_node *temp;
    while(stack != NULL)
    {
        temp = stack->next;
        free(stack);
        stack = temp;
    }
}
long ft_atol(char *morc)
{
    int i;
    long res;
    int signe;

    i = 0;
    signe = 1;
    res = 0;
	while (morc[i] == ' ' || (morc[i] >= 9 && morc[i] <= 13))
		i++;
    if(morc[i] == '-' || morc[i] == '+')
    {
        if(morc[i] == '-')
            signe = -1;
        i++;
    }
    while(morc[i] >= '0' && morc[i] <= '9')
    {
        res = res * 10 + (morc[i] - '0');
        i++;
    }
    return (res * signe);
}

int is_nbr(char *morc)
{
    int i;

    if (!morc || !*morc)
        return(0);
    i = 0;
    if(morc[i] == '-' || morc[i] == '+')
        i++;
    if(!morc[i])
        return(0);
    while(morc[i])
    {
        if(!(morc[i] >= '0' && morc[i] <= '9'))
            return(0);
        i++;
    }
    return (1);
}

int is_nbr_double(int nbr, t_node *stack)
{
    while (stack != NULL)
    {
        if (stack->value == nbr)
            return (0);
        stack = stack->next;
    }
    return (1);
}
int add_to_stack(int nbr,t_node **stack)
{
    t_node *node;

    node = malloc(sizeof(t_node));
    if(!node)
        return (0);
    node->value = nbr;
    node->next = *stack;
    *stack = node;
    return (1);
}
