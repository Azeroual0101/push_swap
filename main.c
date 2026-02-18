#include "push_swap.h"
#include <stdio.h>
#include <stdlib.h>

// Fonction pour afficher la pile (pour debug)
void print_stack(t_node *stack)
{
    while (stack)
    {
        printf("%d ", stack->value);
        stack = stack->next;
    }
}

int main(int argc, char **argv)
{
    t_node *a = NULL;
    t_node *b = NULL;
    int size;

    // ===== PARSING =====
    a = pars_argmnts(argc, argv);
    
    // Si erreur de parsing
    if (a == NULL)
    {
        if (argc > 1)  // Évite d'afficher pour "aucun argument"
            printf("Error\n");
        return (1);
    }
    
    // ===== TRI =====
    size = ft_size(&a);
    
    if (size <= 1)
    {
        // Déjà trié, rien à faire
    }
    else if (size == 2)
        sort_two(&a);
    else if (size == 3)
        sort_three(&a);
    else if (size == 4)
        sort_four(&a);
    else if (size == 5)
        sort_five(&a);
    else
    {
        radix_sort(&a);
    }
    
    // ===== AFFICHAGE POUR LE TESTEUR =====
    // Le script tester.sh attend la liste des opérations
    // ou rien si déjà trié
    
    // ===== LIBÉRATION =====
    ft_free_stack(a);
    ft_free_stack(b);
    
    return (0);
}