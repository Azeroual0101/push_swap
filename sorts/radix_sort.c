/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   radix_sort.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/11 11:48:41 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/11 15:18:53 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

int ft_max_bits(int size)
{
    int bin_max;

    bin_max = 0;
    while (((size - 1) >> bin_max) != 0)
        bin_max++;
    return (bin_max);
}
t_node  *radix_sort(t_node **a)
{
    t_node *b;
    int max_bits;
    int i; 

    max_bits = ft_max_bits(ft_size(a));
    if (*a == NULL || (*a)->next == NULL)
        return (NULL);
    if (is_sorted(*a))
        return (*a);
    tri_stack(a);
    b = NULL;
    i = 0;
    while (i < max_bits)
    {
        while ((*a) != NULL)
        {
            if ( (((*a) -> index) >> i) & 1 )
            ft_ra(a);
        else
            ft_pb(a, &b);
        }
        while (b)
            ft_pa(a,&b);
        i++;
    }
    return (*a);
}
