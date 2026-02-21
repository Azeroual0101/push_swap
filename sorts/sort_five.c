/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_five.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 23:09:21 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/20 23:49:45 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

static void	find_two_smallest(t_node *a, int *min1, int *min2)
{
	t_node	*curr;
	int		temp;

	*min1 = a->value;
	*min2 = a->next->value;
	if (*min1 > *min2)
	{
		temp = *min1;
		*min1 = *min2;
		*min2 = temp;
	}
	curr = a->next->next;
	while (curr)
	{
		if (curr->value < *min1)
		{
			*min2 = *min1;
			*min1 = curr->value;
		}
		else if (curr->value < *min2 && curr->value != *min1)
			*min2 = curr->value;
		curr = curr->next;
	}
}

static void	push_in_b(t_node **a, t_node **b, int value)
{
	t_node	*curr;
	int		position;
	int		size;

	position = 0;
	curr = *a;
	size = ft_size(a);
	while (curr && curr->value != value)
	{
		position++;
		curr = curr->next;
	}
	if (position <= size / 2)
	{
		while ((*a)->value != value)
			ft_ra(a);
	}
	else
	{
		while ((*a)->value != value)
			ft_rra(a);
	}
	ft_pb(a, b);
}

void	sort_five(t_node **a)
{
	t_node	*b;
	int		min1;
	int		min2;

	if (!*a || !(*a)->next)
		return ;
	b = NULL;
	find_two_smallest(*a, &min1, &min2);
	push_in_b(a, &b, min1);
	push_in_b(a, &b, min2);
	sort_three(a);
	ft_pa(a, &b);
	ft_pa(a, &b);
}
