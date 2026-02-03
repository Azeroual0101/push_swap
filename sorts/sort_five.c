/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_five.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/03 13:18:01 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/03 13:36:41 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void sort_five(t_node **a)
{
    t_node  *b;
    t_node  *index;
    int min1;
    int min2;
    t_node  *curr;

    min1 = (*a) -> value;
    min2 = (*a) -> next -> value;

    curr = (*a);
    while(curr != NULL)
    {
        if(curr -> value < min1)
        {
            min1 = curr -> value;
            index = curr;
        }
        curr = curr -> next;
    }
    ft_pb(&index,&b);
    curr = (*a);
    while(curr != NULL)
    {
        if(curr -> value < min2 || (curr -> value != min1))
        {
            min2 = curr -> value;
            index = curr;
        }
        curr = curr -> next;
    }
    ft_pb(&index,&b);
    sort_three(a);
    ft_pa(a,&b);
    ft_pb(a,&b);
}