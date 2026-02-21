/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_four.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/20 23:52:13 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/20 23:52:36 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void	sort_four(t_node **a)
{
	t_node	*curr;
	t_node	*b;
	int		min;

	if (!(*a) || !(*a)->next)
		return ;
	curr = *a;
	min = curr->value;
	b = NULL;
	while (curr)
	{
		if (curr->value < min)
			min = curr->value;
		curr = curr->next;
	}
	while (((*a)->value) != min)
		ft_ra(a);
	ft_pb(a, &b);
	sort_three(a);
	ft_pa(a, &b);
}
