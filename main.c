/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/21 15:55:46 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/22 23:47:33 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static void	print_error(void)
{
	write(2, "Error\n", 6);
}

static void	sort_stack(t_node **a)
{
	int	size;

	size = ft_size(a);
	if (size == 2)
		sort_two(a);
	else if (size == 3)
		sort_three(a);
	else if (size == 4)
		sort_four(a);
	else if (size == 5)
		sort_five(a);
	else
		radix_sort(a);
}

int	main(int argc, char **argv)
{
	t_node	*a;
	t_node	*b;

	if (argc < 2)
		return (0);
	a = pars_argmnts(argc, argv);
	if (!a)
	{
		print_error();
		exit(1);
	}
	if (is_sorted(a))
	{
		ft_free_stack(a);
		exit(0);
	}
	b = NULL;
	sort_stack(&a);
	ft_free_stack(a);
	ft_free_stack(b);
	return (0);
}
