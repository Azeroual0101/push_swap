#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <stdlib.h>
# include <unistd.h>
# include <limits.h>
# include <stdio.h>

typedef struct s_node
{
    int             value;
    int             index;
    struct s_node   *next;
} t_node;

/* ************************************************************************** */
/*                            PARSING FUNCTIONS                               */
/* ************************************************************************** */

t_node	*pars_argmnts(int argc, char **argv);
t_node	*handle_argv(char *argv);
t_node	*handle_morceaux(char **morceaux, t_node *stack);
int		is_valide(char *morc, int *nbr);

/* ************************************************************************** */
/*                            UTILITY FUNCTIONS                               */
/* ************************************************************************** */

void	ft_free_split(char **tab);
void	ft_free_stack(t_node *stack);
long	ft_atol(char *morc);
int		is_nbr(char *morc);
int		is_nbr_double(int nbr, t_node *stack);
int		add_to_stack(int nbr, t_node **stack);

/* ************************************************************************** */
/*                            LIBFT FUNCTIONS                                 */
/* ************************************************************************** */

int		ft_atoi(const char *str);
char	**ft_split(char const *s, char c);

/* ************************************************************************** */
/*                          ADDITIONAL FUNCTIONS                              */
/* ************************************************************************** */

t_node	*merge_stack(t_node *stack1, t_node *stack2);
void	free_split(char **morceaux);
void	free_stack(t_node *stack);

/* ************************************************************************** */
/*                            PUSH FUNCTIONS                               */
/* ************************************************************************** */

void    ft_pb(t_node **a, t_node **b);
void    ft_pa(t_node **a, t_node **b);

/* ************************************************************************** */
/*                            ROTATE FUNCTIONS                               */
/* ************************************************************************** */

void    ft_rstack(t_node **stack);
void    ft_rrstack(t_node **stack);

void    ft_ra(t_node **a);
void    ft_rb(t_node **b);
void    ft_rr(t_node **a, t_node **b);
void    ft_rra(t_node **a);
void    ft_rrb(t_node **b);
void    ft_rrr(t_node **a, t_node **b);

/* ************************************************************************** */
/*                            SWAP FUNCTIONS                               */
/* ************************************************************************** */

void    ft_s(t_node **stack);
void    ft_sa(t_node **a);
void    ft_sb(t_node **a);
void    ft_ss(t_node **a ,t_node **b);

/* ************************************************************************** */
/*                            SORT FUNCTIONS                               */
/* ************************************************************************** */

void	sort_three(t_node **a);
void    sort_five(t_node **a);
void    sort_tab(int *tab, int size);
int     is_sorted(t_node *stack);
int     *index_stack(t_node **a);
t_node  *tri_stack(t_node **a);
int     ft_max_bits(int size);
t_node  *radix_sort(t_node **a);
int     ft_size(t_node  **a);


#endif
