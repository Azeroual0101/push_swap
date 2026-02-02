/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/10/22 11:04:06 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/02 00:40:40 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "push_swap.h"

static	int	cal_len(char const *s, char c)
{
	int	in_word;
	int	i;
	int	len;

	i = 0;
	in_word = 0;
	len = 0;
	while (s[i])
	{
		if (s[i] != c && in_word == 0)
		{
			len++;
			in_word = 1;
		}
		else if (s[i] == c)
			in_word = 0;
		i++;
	}
	return (len);
}

static	char	*ins_word(const char *s, char c, int *index)
{
	char	*str;
	int		start;
	int		end;
	int		len;
	int		i;

	while (s[*index] && s[*index] == c)
		(*index)++;
	start = *index;
	while (s[*index] && s[*index] != c)
		(*index)++;
	end = *index;
	len = end - start;
	str = malloc((len + 1) * sizeof(char));
	if (!str)
		return (NULL);
	i = 0;
	while (i < len)
	{
		str[i] = s[start + i];
		i++;
	}
	str[i] = '\0';
	return (str);
}

static char	**remp_tab(char const *s, char **tab, char c, size_t len)
{
	size_t	j;
	int		i;

	j = 0;
	i = 0;
	while (j < len)
	{
		tab[j] = ins_word(s, c, &i);
		if (!tab[j])
		{
			while (j > 0)
				free(tab[--j]);
			free(tab);
			return (NULL);
		}
		j++;
	}
	tab[j] = NULL;
	return (tab);
}

char	**ft_split(char const *s, char c)
{
	char	**tab;
	size_t	len_tab;

	if (!s || !*s)
	{
		tab = malloc(sizeof(char *));
		if (!tab)
			return (NULL);
		tab[0] = NULL;
		return (tab);
	}
	len_tab = cal_len(s, c);
	tab = malloc((len_tab + 1) * sizeof(char *));
	if (!tab)
		return (NULL);
	tab = remp_tab(s, tab, c, len_tab);
	return (tab);
}
