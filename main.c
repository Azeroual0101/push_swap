#include "push_swap.h"
#include <stdio.h>

// Fonction utilitaire pour afficher la pile
void print_stack(t_node *stack, char *name)
{
    printf("%s: ", name);
    if (!stack)
    {
        printf("(vide)\n");
        return;
    }
    
    while (stack)
    {
        printf("%d", stack->value);
        if (stack->next)
            printf(" -> ");
        stack = stack->next;
    }
    printf("\n");
}

// Test 1: Arguments normaux
void test_normal()
{
    printf("=== TEST 1: Arguments normaux ===\n");
    char *argv[] = {"./push_swap", "12", "45", "-7", "89", "0"};
    int argc = 6;
    
    t_node *stack = pars_argmnts(argc, argv);
    print_stack(stack, "Stack A");
    free_stack(stack);
    printf("✓ Test réussi\n\n");
}

// Test 2: Un seul argument avec plusieurs nombres
void test_single_arg_multiple_numbers()
{
    printf("=== TEST 2: Un argument avec plusieurs nombres ===\n");
    char *argv[] = {"./push_swap", "12 45 -7 89 0"};
    int argc = 2;
    
    t_node *stack = pars_argmnts(argc, argv);
    print_stack(stack, "Stack A");
    free_stack(stack);
    printf("✓ Test réussi\n\n");
}

// Test 3: Mix des deux
void test_mixed()
{
    printf("=== TEST 3: Mix d'arguments ===\n");
    char *argv[] = {"./push_swap", "12 45", "-7", "89 0"};
    int argc = 4;
    
    t_node *stack = pars_argmnts(argc, argv);
    print_stack(stack, "Stack A");
    free_stack(stack);
    printf("✓ Test réussi\n\n");
}

// Test 4: Doublons (doit échouer)
void test_doublons()
{
    printf("=== TEST 4: Doublons (doit échouer) ===\n");
    char *argv[] = {"./push_swap", "12 45 12 89"};
    int argc = 2;
    
    t_node *stack = pars_argmnts(argc, argv);
    if (!stack)
        printf("✓ Correctement rejeté (doublon détecté)\n");
    else
    {
        printf("✗ ERREUR: Doublon non détecté!\n");
        free_stack(stack);
    }
    printf("\n");
}

// Test 5: Nombre trop grand (doit échouer)
void test_overflow()
{
    printf("=== TEST 5: Overflow (doit échouer) ===\n");
    char *argv[] = {"./push_swap", "2147483648"};  // INT_MAX + 1
    int argc = 2;
    
    t_node *stack = pars_argmnts(argc, argv);
    if (!stack)
        printf("✓ Correctement rejeté (overflow détecté)\n");
    else
    {
        printf("✗ ERREUR: Overflow non détecté!\n");
        free_stack(stack);
    }
    printf("\n");
}

// Test 6: Nombre trop petit (doit échouer)
void test_underflow()
{
    printf("=== TEST 6: Underflow (doit échouer) ===\n");
    char *argv[] = {"./push_swap", "-2147483649"};  // INT_MIN - 1
    int argc = 2;
    
    t_node *stack = pars_argmnts(argc, argv);
    if (!stack)
        printf("✓ Correctement rejeté (underflow détecté)\n");
    else
    {
        printf("✗ ERREUR: Underflow non détecté!\n");
        free_stack(stack);
    }
    printf("\n");
}

// Test 7: Caractères invalides (doit échouer)
void test_invalid_chars()
{
    printf("=== TEST 7: Caractères invalides (doit échouer) ===\n");
    char *argv[] = {"./push_swap", "12a 45"};
    int argc = 2;
    
    t_node *stack = pars_argmnts(argc, argv);
    if (!stack)
        printf("✓ Correctement rejeté (caractère invalide)\n");
    else
    {
        printf("✗ ERREUR: Caractère invalide accepté!\n");
        free_stack(stack);
    }
    printf("\n");
}

// Test 8: Vide ou seulement le nom du programme
void test_empty()
{
    printf("=== TEST 8: Aucun argument ===\n");
    char *argv[] = {"./push_swap"};
    int argc = 1;
    
    t_node *stack = pars_argmnts(argc, argv);
    if (!stack)
        printf("✓ Correct: NULL retourné pour aucun argument\n");
    else
    {
        printf("✗ ERREUR: Devrait retourner NULL\n");
        free_stack(stack);
    }
    printf("\n");
}

// Test 9: Avec signes +
void test_plus_sign()
{
    printf("=== TEST 9: Nombres avec signe + ===\n");
    char *argv[] = {"./push_swap", "+12", "-45", "+0"};
    int argc = 4;
    
    t_node *stack = pars_argmnts(argc, argv);
    print_stack(stack, "Stack A");
    free_stack(stack);
    printf("✓ Test réussi\n\n");
}

// Test 10: Grand nombre d'arguments
void test_many_args()
{
    printf("=== TEST 10: Beaucoup d'arguments ===\n");
    char *argv[] = {"./push_swap", 
                    "1", "2", "3", "4", "5",
                    "6", "7", "8", "9", "10",
                    "11", "12", "13", "14", "15"};
    int argc = 16;
    
    t_node *stack = pars_argmnts(argc, argv);
    print_stack(stack, "Stack A");
    free_stack(stack);
    printf("✓ Test réussi (15 nombres)\n\n");
}

// Fonction principale
int main(void)
{
    printf("========== TESTS PARSING PUSH_SWAP ==========\n\n");
    
    test_normal();
    test_single_arg_multiple_numbers();
    test_mixed();
    test_doublons();
    test_overflow();
    test_underflow();
    test_invalid_chars();
    test_empty();
    test_plus_sign();
    test_many_args();
    
    printf("========== FIN DES TESTS ==========\n");
    return (0);
}