/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   base_rotate.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 23:03:43 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/23 00:49:47 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void	ft_rstack(t_node **stack)
{
	t_node	*temp;
	t_node	*last;

	if (*stack == NULL || (*stack)->next == NULL)
		return ;
	last = *stack;
	while (last->next != NULL)
		last = last->next;
	temp = *stack;
	*stack = (*stack)->next;
	last->next = temp;
	temp->next = NULL;
}

void	ft_rrstack(t_node **stack)
{
	t_node	*temp;
	t_node	*last;

	if (*stack == NULL || (*stack)->next == NULL)
		return ;
	last = *stack;
	while (last->next->next != NULL)
		last = last->next;
	temp = last->next;
	last->next = NULL;
	temp->next = *stack;
	*stack = temp;
}
