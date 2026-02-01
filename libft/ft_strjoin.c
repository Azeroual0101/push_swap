/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strjoin.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/25 01:06:07 by abdazero          #+#    #+#             */
/*   Updated: 2025/11/02 20:14:38 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static void	ft_concat(char *cnct, char const *s1, char const *s2)
{
	int	i;
	int	j;

	i = 0;
	j = 0;
	while (s1[i])
	{
		cnct[i] = s1[i];
		i++;
	}
	while (s2[j])
	{
		cnct[i] = s2[j];
		i++;
		j++;
	}
	cnct[i] = '\0';
}

char	*ft_strjoin(char const *s1, char const *s2)
{
	size_t	size_cnct;
	char	*cnct;

	if (!s1 && !s2)
		return (NULL);
	if (!s1)
		return (ft_strdup(s2));
	if (!s2)
		return (ft_strdup(s1));
	size_cnct = ft_strlen(s2) + ft_strlen(s1);
	cnct = malloc((size_cnct + 1) * sizeof(char));
	if (!cnct)
		return (NULL);
	ft_concat(cnct, s1, s2);
	return ((char *)cnct);
}
