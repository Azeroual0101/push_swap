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
int		ajout_stack(int nbr, t_node **stack);

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

#endif
