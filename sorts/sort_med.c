/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sort_med.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/20 23:53:08 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/20 23:54:19 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

void	find_k_smallest(t_node *stack, int *result, int k)
{
	int		size;
	t_node	*curr;
	int		*temp;
	int		i;

	size = ft_size(&stack);
	temp = malloc(sizeof(int) * size);
	if (!temp)
		return ;
	i = 0;
	curr = stack;
	while (curr)
	{
		temp[i++] = curr->value;
		curr = curr->next;
	}
	sort_tab(temp, size);
	i = 0;
	while (i < k)
	{
		result[i] = temp[i];
		i++;
	}
	free(temp);
}

static void	push_smallest_to_b(t_node **a, t_node **b, int *res, int count)
{
	int	i;

	i = 0;
	while (i < count)
	{
		while ((*a)->value != res[i])
			ft_ra(a);
		ft_pb(a, b);
		i++;
	}
}

static void	sort_remaining(t_node **a, int remaining)
{
	if (remaining == 2)
		sort_two(a);
	else if (remaining == 3)
		sort_three(a);
	else if (remaining == 4)
		sort_four(a);
	else if (remaining == 5)
		sort_five(a);
	else
		sort_med(a);
}

void	sort_med(t_node **a)
{
	int		size;
	int		push_count;
	int		remaining;
	int		*result;
	t_node	*b;

	size = ft_size(a);
	push_count = size / 2;
	result = malloc(sizeof(int) * push_count);
	if (!result)
		return ;
	find_k_smallest(*a, result, push_count);
	b = NULL;
	push_smallest_to_b(a, &b, result, push_count);
	remaining = size - push_count;
	sort_remaining(a, remaining);
	while (b)
		ft_pa(a, &b);
	free(result);
}
