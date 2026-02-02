#!/bin/bash

echo "=== TEST DES FUITES MÉMOIRE ==="
echo ""

# Compile avec debug si nécessaire
if [ ! -f "./push_swap_debug" ]; then
    echo "Compilation avec infos debug..."
    gcc -g main.c push_swap.a -o push_swap_debug
fi

# Fonction de test
run_valgrind() {
    local test_name="$1"
    local command="$2"
    
    echo "=== $test_name ==="
    echo "Commande: $command"
    echo ""
    
    # Exécute avec valgrind et capture la sortie
    eval "valgrind --leak-check=full --show-leak-kinds=all $command 2>&1"
    
    echo ""
    echo "-------------------------------"
    echo ""
}

# Tests
run_valgrind "Test 1: Arguments normaux" "./push_swap_debug 12 45 -7 89 0"
run_valgrind "Test 2: Avec doublon" "./push_swap_debug 12 45 12 89"
run_valgrind "Test 3: Avec overflow" "./push_swap_debug 2147483648"
run_valgrind "Test 4: Aucun argument" "./push_swap_debug"
run_valgrind "Test 5: Caractère invalide" "./push_swap_debug 12a 45"

echo "=== FIN DES TESTS ==="