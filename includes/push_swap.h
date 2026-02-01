#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <stdlib.h>
# include <unistd.h>
# include <limits.h>


typedef struct s_node
{
    int             value;
    int             index;
    struct s_node   *next;
} t_node;


t_node *parse_arguments(int argc, char **argv);
int     validate_number(char *str);
int     check_duplicates(t_node *stack, int num);
t_node *create_node(int value);


void    ft_putstr(char *str);
int     ft_atoi(const char *str);
int     ft_isdigit(int c);

#endif