t_node *pars_argmnts(int argc,char **argv)
{
    t_node *stack;
    t_node *temp;
    int     i;

    if (argv < 2)
        return (NULL);


    i = 0;
    while (i < argc)
    {
        temp = handle_argv(argv[i]) 
    }
}

t_node *handle_argv(char **argv)
{
    char **morceaux;
    t_node *stack;

    morceaux = ft_split(argv,' ')
    if (!morceaux)
        return (NULL);
    stack = handle_morceaux(morceaux,NULL);
    free_split(morceaux);
    return (stack);
}

t_node *handle_morceaux(char **morceaux,t_node *stack)
{
    int i;
    int nbr;

    i = 0;
    while(morceaux[i])
    {
        if(!is_valide(morceaux[i],&nbr))
            return (NULL);
        if(!is_nbr_double(nbr,stack))
            return(NULL);
        if (!ajout_stack(nbr,&stack))
            return (NULL);
        i++;
    }
    return (stack);
}

int is_valide(char *morc,int *nbr)
{
    if(!is_nbr(morc))
        return(0);
    *nbr = ft_atoi(morc);
    return(*nbr != ERREUR_OVERFLOW)
}

int is_nbr(char *morc)
