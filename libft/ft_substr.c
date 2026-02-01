/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_substr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/24 23:08:11 by abdazero          #+#    #+#             */
/*   Updated: 2025/11/02 20:13:17 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static	size_t	ft_substr_len(const char *s, unsigned int start, size_t len)
{
	size_t	len_s;

	if (!s)
		return (0);
	len_s = ft_strlen(s);
	if (start >= len_s)
		return (0);
	if (len > len_s - start)
		len = len_s - start;
	return (len);
}

char	*ft_substr(char const *s, unsigned int start, size_t len)
{
	char	*res;
	size_t	i;
	size_t	sub_len;

	if (!s)
		return (NULL);
	sub_len = ft_substr_len(s, start, len);
	res = malloc(sub_len + 1);
	if (!res)
		return (NULL);
	i = 0;
	while (i < sub_len && s[start + i])
	{
		res[i] = s[start + i];
		i++;
	}
	res[i] = '\0';
	return (res);
}
