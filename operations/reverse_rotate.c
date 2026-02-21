/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   reverse_rotate.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 21:51:49 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/20 22:09:15 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void	ft_rra(t_node **a)
{
	ft_rrstack(a);
	write(1, "rra\n", 4);
}

void	ft_rrb(t_node **b)
{
	ft_rrstack(b);
	write(1, "rrb\n", 4);
}

void	ft_rrr(t_node **a, t_node **b)
{
	ft_rrstack(a);
	ft_rrstack(b);
	write(1, "rrr\n", 4);
}
