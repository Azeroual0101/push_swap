/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_itoa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/20 10:38:42 by abdazero          #+#    #+#             */
/*   Updated: 2025/10/30 11:22:04 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static	int	lenstr(long nb)
{
	int	len;

	len = 0;
	if (nb <= 0)
		len++;
	while (nb)
	{
		nb = nb / 10;
		len++;
	}
	return (len);
}

char	*ft_itoa(int n)
{
	int			len_str;
	long		nb;
	char		*str;

	nb = n;
	len_str = lenstr(nb);
	str = malloc(sizeof(char) * (len_str + 1));
	if (!str)
		return (NULL);
	str[len_str] = '\0';
	if (nb < 0)
	{
		str[0] = '-';
		nb = -nb;
	}
	if (nb == 0)
		str[0] = '0';
	while (nb)
	{
		len_str--;
		str[len_str] = (nb % 10) + '0';
		nb /= 10;
	}
	return (str);
}
