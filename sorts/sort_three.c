/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_three.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/03 11:39:54 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/22 23:34:12 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void	sort_three(t_node **a)
{
	int	first;
	int	second;
	int	third;

	if (!*a || !(*a)->next || !(*a)->next->next)
		return ;
	first = (*a)->value;
	second = (*a)->next->value;
	third = (*a)->next->next->value;
	if (first > second && second < third && first > third)
		ft_ra(a);
	else if (first < second && second > third && first > third)
		ft_rra(a);
	else if (first > second && second > third)
	{
		ft_sa(a);
		ft_rra(a);
	}
	else if (first > second && second < third)
		ft_sa(a);
	else if (first < second && second > third)
	{
		ft_sa(a);
		ft_ra(a);
	}
}
