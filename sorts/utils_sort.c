/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils_sort.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/11 00:13:36 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/11 01:59:29 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void    sort_tab(int *tab, int size)
{
    int i;
    int j;
    int min;
    int tmp;

    i = 0;
    while(i < size)
    {
        min = i;
        j = i + 1;
         while (j < size)
        {
            if(tab[j] < tab[min])
                min = j;
            j++;
        }
        tmp = tab[i];
        tab[i] = tab[min];
        tab[min] = tmp;
        i++;
    }
}
int	is_sorted(t_node *stack)
{
	while (stack && stack->next)
	{
		if (stack->value > stack->next->value)
			return (0);
		stack = stack->next;
	}
	return (1);
}

int *index_stack(t_node **a)
{
    int size;
    int *tab;
    int i;
    t_node *curr;

    size = ft_size(a);
    tab = malloc(sizeof(int) * size);
    if(!tab)
        return (NULL);
    i = 0;
    curr = *a;
    while (i < size)
    {
        tab[i] = curr -> value;
        curr = curr -> next;
        i++;
    }
    sort_tab(tab, size);
    return (tab);
}

t_node *tri_stack(t_node **a)
{
    int *tab;
    int size;
    int i;
    t_node *curr;

    size = ft_size(a);
    tab = index_stack(a);
    if(!tab)
        return (NULL);
    i = 0;
    while (i < size)
    {
        curr = (*a);
        while (curr != NULL)
        {
            if (tab[i] == curr -> value)
            {
                curr -> index = i;
                break;
            }
            curr = curr -> next;
        }
        i++;
    }

    free(tab);
    return (*a);
}