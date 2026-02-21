/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils_1.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 23:03:30 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/20 23:45:57 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

long	ft_atol(char *morc)
{
	int		i;
	long	res;
	int		signe;

	i = 0;
	signe = 1;
	res = 0;
	while (morc[i] == ' ' || (morc[i] >= 9 && morc[i] <= 13))
		i++;
	if (morc[i] == '-' || morc[i] == '+')
	{
		if (morc[i] == '-')
			signe = -1;
		i++;
	}
	while (morc[i] >= '0' && morc[i] <= '9')
	{
		res = res * 10 + (morc[i] - '0');
		i++;
	}
	return (res * signe);
}

int	is_nbr(char *morc)
{
	int	i;

	if (!morc || !*morc)
		return (0);
	i = 0;
	if (morc[i] == '-' || morc[i] == '+')
		i++;
	if (!morc[i])
		return (0);
	while (morc[i])
	{
		if (!(morc[i] >= '0' && morc[i] <= '9'))
			return (0);
		i++;
	}
	return (1);
}

int	is_nbr_double(int nbr, t_node *stack)
{
	while (stack != NULL)
	{
		if (stack->value == nbr)
			return (0);
		stack = stack->next;
	}
	return (1);
}

int	add_to_stack(int nbr, t_node **stack)
{
	t_node	*node;
	t_node	*last;

	node = malloc(sizeof(t_node));
	if (!node)
		return (0);
	node->value = nbr;
	node->next = NULL;
	if (*stack == NULL)
	{
		*stack = node;
		return (1);
	}
	last = *stack;
	while (last->next)
		last = last->next;
	last->next = node;
	return (1);
}
