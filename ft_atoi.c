/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/19 20:16:43 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/02 00:40:45 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static	int	ft_isspace(int c)
{
	if (c == 9 || c == 10 || c == 11 || c == 12 || c == 13 || c == 32)
		return (1);
	return (0);
}

static	int	signe(int sign)
{
	if (sign == 1)
		return (-1);
	return (0);
}

static	long	ft_cnvrt(const char *str, int i, long *result, int sign)
{
	long	preres;

	while (str[i] && str[i] >= '0' && str[i] <= '9')
	{
		preres = *result;
		*result = *result * 10 + (str[i] - '0');
		if (*result / 10 != preres)
		{
			*result = signe(sign);
			return ((long )*result);
		}
		i++;
	}
	*result *= sign;
	return ((long) *result);
}

int	ft_atoi(const char *str)
{
	long	result;
	int		sign;
	int		i;
	long	ret;

	result = 0;
	sign = 1;
	i = 0;
	while (ft_isspace(str[i]))
		i++;
	if (str[i] == '+' && str[i + 1] != '-')
		i++;
	if (str[i] == '-')
	{
		sign = -1;
		i++;
	}
	ret = ft_cnvrt(str, i, &result, sign);
	return ((int)ret);
}
