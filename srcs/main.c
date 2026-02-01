#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>

static int word_count(const char *str, char c);
static char *fill_word(const char *str, int start, int end);
static void *ft_free(char **strs, int count);
static void ft_initiate_vars(size_t *i, int *j, int *s_word);
int ft_strlen(const char *s)
{
    int len = 0;
    while (s[len])
        len++;
    return (len);
}

char **ft_split(const char *s, char c)
{
    char **res;
    size_t i;
    int j;
    int s_word;

    ft_initiate_vars(&i, &j, &s_word);
    res = calloc((word_count(s, c) + 1), sizeof(char *));
    if (!res)
        return (NULL);

    while (i <= ft_strlen(s))
    {
        if (s[i] != c && s_word < 0)
            s_word = i;
        else if ((s[i] == c || i == ft_strlen(s)) && s_word >= 0)
        {
            res[j] = fill_word(s, s_word, i);
            if (!(res[j]))
                return (ft_free(res, j));
            s_word = -1;
            j++;
        }
        i++;
    }
    return (res);
}

static void ft_initiate_vars(size_t *i, int *j, int *s_word)
{
    *i = 0;
    *j = 0;
    *s_word = -1;
}

static void *ft_free(char **strs, int count)
{
    int i;

    i = 0;
    while (i < count)
    {
        free(strs[i]);
        i++;
    }
    free(strs);
    return (NULL);
}

static char *fill_word(const char *str, int start, int end)
{
    char *word;
    int i;

    i = 0;
    word = malloc((end - start + 1) * sizeof(char));
    if (!word)
        return (NULL);

    while (start < end)
    {
        word[i] = str[start];
        i++;
        start++;
    }
    word[i] = 0;
    return (word);
}

static int word_count(const char *str, char c)
{
    int count;
    int x;

    count = 0;
    x = 0;

    while (*str)
    {
        if (*str != c && x == 0)
        {
            x = 1;
            count++;
        }
        else if (*str == c)
            x = 0;
        str++;
    }
    return (count);
}

// Dans parse_args.c
t_node *parse_arguments(int argc, char **argv)
{
    t_node *stack_a;
    char **mots;
    int nombre;
    int j;
    
    // Initialisation
    stack_a = NULL;
    
    // Vérifier arguments
    if (argc < 2)
        return (NULL);
    
    // Pour chaque argument
    for (int i = 1; i < argc; i++)
    {
        // Découper sur espaces
        mots = ft_split(argv[i], ' ');
        
        // Pour chaque mot obtenu
        j = 0;
        while (mots[j])
        {
            // Valider le mot
            if (!est_nombre_valide(mots[j]))
                return (erreur_et_cleanup(&stack_a, mots));
            
            // Convertir
            nombre = ft_atoi_modifie(mots[j]);
            if (nombre == ERREUR_OVERFLOW)
                return (erreur_et_cleanup(&stack_a, mots));
            
            // Vérifier doublon
            if (doublon_existe(stack_a, nombre))
                return (erreur_et_cleanup(&stack_a, mots));
            
            // Ajouter à la pile
            if (!ajouter_noeud(&stack_a, nombre))
                return (erreur_et_cleanup(&stack_a, mots));
            
            j++;
        }
        
        // Libérer mots
        liberer_tableau(mots);
    }
    
    return (stack_a);
}