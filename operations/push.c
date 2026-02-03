/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 23:03:39 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/02 23:03:41 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void ft_pb(t_node **a, t_node **b)
{
    t_node *temp;

    if (*a == NULL)
        return ;
    temp = *a;
    *a = (*a) -> next;
    temp -> next = *b;
    *b = temp;
}
void ft_pa(t_node **a, t_node **b)
{
    t_node *temp;

    if (*b == NULL)
        return ;
    temp = *b;
    *b = (*b) -> next;
    temp -> next = *a;
    *a = temp;
}

