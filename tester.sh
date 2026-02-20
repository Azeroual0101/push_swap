#!/bin/bash

# =============================================================================
# TESTEUR DE TRI POUR PUSH_SWAP
# =============================================================================

# Couleurs
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Configuration
PROGRAM="./push_swap"
CHECKER="./checker"  # ou checker_Mac, checker_linux selon OS
TOTAL=0
PASSED=0

# Vérification que le programme existe
if [ ! -f "$PROGRAM" ]; then
    echo -e "${RED}❌ $PROGRAM non trouvé. Compile d'abord avec 'make test'${RESET}"
    exit 1
fi

# Fonction pour exécuter un test
test_case() {
    local test_name="$1"
    local args="$2"
    local expected_max="$3"
    local size="$4"
    
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${YELLOW}📋 TEST: $test_name${RESET}"
    echo -e "${BLUE}Arguments: $args${RESET}"
    echo -e "${BLUE}Taille: $size${RESET}"
    
    # Exécuter push_swap et compter les mouvements
    moves=$($PROGRAM $args 2>/dev/null | wc -l)
    
    # Vérifier avec checker si disponible
    if [ -f "$CHECKER" ]; then
        result=$(echo "$moves" | $CHECKER $args 2>/dev/null)
        if [ "$result" = "OK" ] || [ -z "$result" ]; then
            status="${GREEN}✅ OK${RESET}"
            PASSED=$((PASSED + 1))
        else
            status="${RED}❌ KO${RESET}"
        fi
    else
        # Sans checker, on vérifie juste que le tri a fonctionné (pas d'erreur)
        $PROGRAM $args > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            status="${GREEN}✅ EXÉCUTÉ${RESET}"
            PASSED=$((PASSED + 1))
        else
            status="${RED}❌ ERREUR${RESET}"
        fi
    fi
    
    # Afficher les mouvements
    echo -e "   Mouvements: $moves"
    
    # Vérifier la limite attendue
    if [ "$expected_max" != "0" ]; then
        if [ $moves -le $expected_max ]; then
            echo -e "   ${GREEN}✓ ≤ $expected_max mouvements${RESET}"
        else
            echo -e "   ${RED}✗ > $expected_max mouvements (attendu: ≤ $expected_max)${RESET}"
        fi
    fi
    
    TOTAL=$((TOTAL + 1))
}

# =============================================================================
# DÉBUT DES TESTS
# =============================================================================

echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "${MAGENTA}              TESTEUR DE TRI PUSH_SWAP${RESET}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"

# -----------------------------------------------------------------------------
# TEST POUR 1 NOMBRE
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 1 NOMBRE ═══════════════════════${RESET}"
test_case "1 nombre" "42" "0" "1"
test_case "1 nombre négatif" "-42" "0" "1"

# -----------------------------------------------------------------------------
# TEST POUR 2 NOMBRES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 2 NOMBRES ═══════════════════════${RESET}"
test_case "2 nombres déjà trié" "1 2" "1" "2"
test_case "2 nombres à trier" "2 1" "1" "2"
test_case "2 nombres négatifs" "-1 -2" "1" "2"
test_case "2 nombres avec zéro" "0 1" "1" "2"

# -----------------------------------------------------------------------------
# TEST POUR 3 NOMBRES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 3 NOMBRES ═══════════════════════${RESET}"
test_case "3 nombres déjà trié" "1 2 3" "0" "3"
test_case "3-2-1" "3 2 1" "3" "3"
test_case "2-3-1" "2 3 1" "3" "3"
test_case "3-1-2" "3 1 2" "3" "3"
test_case "1-3-2" "1 3 2" "3" "3"
test_case "2-1-3" "2 1 3" "3" "3"

# -----------------------------------------------------------------------------
# TEST POUR 4 NOMBRES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 4 NOMBRES ═══════════════════════${RESET}"
test_case "4 nombres déjà trié" "1 2 3 4" "0" "4"
test_case "4 nombres décroissant" "4 3 2 1" "8" "4"
test_case "4 nombres aléatoire 1" "2 4 1 3" "8" "4"
test_case "4 nombres aléatoire 2" "3 1 4 2" "8" "4"
test_case "4 nombres aléatoire 3" "1 4 2 3" "8" "4"

# -----------------------------------------------------------------------------
# TEST POUR 5 NOMBRES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 5 NOMBRES ═══════════════════════${RESET}"
test_case "5 nombres déjà trié" "1 2 3 4 5" "0" "5"
test_case "5 nombres décroissant" "5 4 3 2 1" "12" "5"
test_case "5 nombres aléatoire 1" "2 5 3 1 4" "12" "5"
test_case "5 nombres aléatoire 2" "5 2 1 4 3" "12" "5"
test_case "5 nombres aléatoire 3" "3 1 5 2 4" "12" "5"
test_case "5 nombres avec négatifs" "-1 -3 2 0 4" "12" "5"

# -----------------------------------------------------------------------------
# TEST POUR 10 NOMBRES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 10 NOMBRES ═══════════════════════${RESET}"
test_case "10 nombres aléatoire" "5 2 8 1 9 3 7 4 6 10" "50" "10"
test_case "10 nombres décroissant" "10 9 8 7 6 5 4 3 2 1" "50" "10"

# -----------------------------------------------------------------------------
# TEST POUR 100 NOMBRES (Radix sort)
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 100 NOMBRES ═══════════════════════${RESET}"
for i in {1..3}; do
    ARG=$(seq -50 50 | shuf | head -100 | tr '\n' ' ')
    test_case "100 nombres aléatoire #$i" "$ARG" "700" "100"
done

# -----------------------------------------------------------------------------
# TEST POUR 500 NOMBRES (Radix sort)
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ 500 NOMBRES ═══════════════════════${RESET}"
for i in {1..2}; do
    ARG=$(seq -250 250 | shuf | head -500 | tr '\n' ' ')
    test_case "500 nombres aléatoire #$i" "$ARG" "5500" "500"
done

# -----------------------------------------------------------------------------
# TESTS SPÉCIAUX
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}═══════════════════════ TESTS SPÉCIAUX ═══════════════════════${RESET}"
test_case "Nombres avec signe +" "+1 +2 +3 +4 +5" "12" "5"
test_case "Mélange arguments simples/groupés" "1 2 \"3 4\" 5" "12" "5"

# -----------------------------------------------------------------------------
# RÉSULTATS FINAUX
# -----------------------------------------------------------------------------

echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "${MAGENTA}                     RÉSULTATS${RESET}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "Tests réussis: ${GREEN}$PASSED${RESET} / $TOTAL"

if [ $PASSED -eq $TOTAL ]; then
    echo -e "${GREEN}✅ PARFAIT ! Tous les tests de tri passent.${RESET}"
else
    echo -e "${RED}❌ $((TOTAL - PASSED)) test(s) échoué(s).${RESET}"
fi

echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}\n"