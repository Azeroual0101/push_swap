/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rotate.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 23:02:55 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/20 22:16:34 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void	ft_ra(t_node **a)
{
	ft_rstack(a);
	write(1, "ra\n", 3);
}

void	ft_rb(t_node **b)
{
	ft_rstack(b);
	write(1, "rb\n", 3);
}

void	ft_rr(t_node **a, t_node **b)
{
	if (*a && (*a)->next)
		ft_rstack(a);
	if (*b && (*b)->next)
		ft_rstack(b);
	write(1, "rr\n", 3);
}
