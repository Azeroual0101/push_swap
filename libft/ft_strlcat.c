/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlcat.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/23 21:57:00 by abdazero          #+#    #+#             */
/*   Updated: 2025/11/02 20:29:48 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

size_t	ft_strlcat(char *dst, const char *src, size_t size)
{
	size_t	len_src;
	size_t	len_dst;
	size_t	i;

	len_src = ft_strlen(src);
	if (size == 0)
		return (len_src);
	len_dst = ft_strlen(dst);
	if (len_dst >= size)
		return ((len_src + size));
	i = 0;
	while (src[i] && i < size - 1 - len_dst)
	{
		dst[i + len_dst] = src[i];
		i++;
	}
	dst[len_dst + i] = '\0';
	return (len_dst + len_src);
}
