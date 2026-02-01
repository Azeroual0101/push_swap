/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memmove.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/20 11:11:50 by abdazero          #+#    #+#             */
/*   Updated: 2025/10/27 22:58:07 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memmove(void *dst, const void *src, size_t len)
{
	unsigned char		*t_dst;
	const unsigned char	*t_src;
	size_t				i;

	if (!dst && !src)
		return (NULL);
	if (dst == src)
		return (dst);
	t_dst = (unsigned char *)dst;
	t_src = (const unsigned char *)src;
	if (t_dst > t_src && t_dst < t_src + len)
	{
		i = len;
		while (i-- > 0)
			t_dst[i] = t_src[i];
	}
	else
	{
		ft_memcpy(dst, src, len);
	}
	return (dst);
}
