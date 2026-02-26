/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils_1.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/02 23:03:30 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/26 01:13:36 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../push_swap.h"

static long	parse_number(const char *str, int *i, int sign)
{
	long	result;
	long	prev;

	result = 0;
	while (str[*i] >= '0' && str[*i] <= '9')
	{
		prev = result;
		result = result * 10 + (str[*i] - '0');
		if (result / 10 != prev)
		{
			if (sign == 1)
				return (LONG_MAX);
			else
				return (LONG_MIN);
		}
		(*i)++;
	}
	return (result * sign);
}

long	ft_atol(const char *str)
{
	long	result;
	int		sign;
	int		i;

	i = 0;
	sign = 1;
	while (str[i] == ' ' || (str[i] >= 9 && str[i] <= 13))
		i++;
	if (str[i] == '-' || str[i] == '+')
	{
		if (str[i] == '-')
			sign = -1;
		i++;
	}
	result = parse_number(str, &i, sign);
	return (result);
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
