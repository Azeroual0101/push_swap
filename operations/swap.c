/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   swap.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 22:26:50 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/03 12:54:55 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void    ft_s(t_node **stack)
{
    t_node  *b;
    t_node  *temp;

    if (*stack == NULL || (*stack)->next == NULL)
        return;
    temp = *stack;
    b = temp -> next;
    temp -> next = b -> next;
    b -> next = temp;
    *stack = b;
}

void    ft_sa(t_node **a)
{
    ft_s(a);
    write(1,"sa\n",3);
}

void    ft_sb(t_node **b)
{
    ft_s(b);
    write(1,"sb\n",3);
}

void    ft_ss(t_node **a ,t_node **b)
{
    ft_s(a);
    ft_s(b);
    write(1,"ss\n",3);
}