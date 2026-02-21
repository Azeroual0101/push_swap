/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   radix_sort.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/11 11:48:41 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/21 00:31:44 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

int	ft_max_bits(int size)
{
	int	bin_max;

	bin_max = 0;
	while (((size - 1) >> bin_max) != 0)
		bin_max++;
	return (bin_max);
}

static void	radix_loop(t_node **a, t_node **b, int size, int max_bits)
{
	int	i;
	int	j;

	i = 0;
	while (i < max_bits)
	{
		j = 0;
		while (j < size)
		{
			if ((((*a)->index >> i) & 1) == 1)
				ft_ra(a);
			else
				ft_pb(a, b);
			j++;
		}
		while (*b)
			ft_pa(a, b);
		i++;
	}
}

t_node	*radix_sort(t_node **a)
{
	t_node	*b;
	int		size;
	int		max_bits;

	if (*a == NULL || (*a)->next == NULL)
		return (NULL);
	if (is_sorted(*a))
		return (*a);
	size = ft_size(a);
	max_bits = ft_max_bits(size);
	tri_stack(a, size);
	b = NULL;
	radix_loop(a, &b, size, max_bits);
	return (*a);
}