/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   push_swap.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/22 23:51:01 by abdazero          #+#    #+#             */
/*   Updated: 2026/02/26 01:22:01 by abdazero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <stdlib.h>
# include <unistd.h>
# include <limits.h>

typedef struct s_node
{
	int				value;
	int				index;
	struct s_node	*next;
}	t_node;
t_node	*pars_argmnts(int argc, char **argv);
t_node	*handle_morceaux(char **morceaux, t_node *stack, t_node *orgstack);
int		is_nbr_double(int nbr, t_node *stack);
int		add_to_stack(int nbr, t_node **stack);
int		ft_size(t_node **a);
void	ft_free_split(char **tab);
void	ft_free_stack(t_node *stack);
long	ft_atol(const char *morc);
int		is_nbr(char *morc);
int		ft_atoi(const char *str);
char	**ft_split(char const *s, char c);
int		is_sorted(t_node *stack);
t_node	*tri_stack(t_node **a, int size);
void	ft_rstack(t_node **stack);
void	ft_rrstack(t_node **stack);
void	ft_pb(t_node **a, t_node **b);
void	ft_pa(t_node **a, t_node **b);
void	ft_ra(t_node **a);
void	ft_rb(t_node **b);
void	ft_rr(t_node **a, t_node **b);
void	ft_rra(t_node **a);
void	ft_rrb(t_node **b);
void	ft_rrr(t_node **a, t_node **b);
void	ft_sa(t_node **a);
void	ft_sb(t_node **b);
void	ft_ss(t_node **a, t_node **b);
void	sort_two(t_node **a);
void	sort_three(t_node **a);
void	sort_four(t_node **a);
void	sort_five(t_node **a);
t_node	*radix_sort(t_node **a);

#endif