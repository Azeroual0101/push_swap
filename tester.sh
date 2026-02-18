#!/bin/bash

# =============================================================================
# TESTEUR DE FUITES MÉMOIRE POUR PUSH_SWAP
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
TOTAL=0
LEAKS=0
OK=0

# Vérification que le programme existe
if [ ! -f "$PROGRAM" ]; then
    echo -e "${RED}❌ $PROGRAM non trouvé. Compile d'abord avec 'make test'${RESET}"
    exit 1
fi

# Vérification que valgrind est installé
if ! command -v valgrind &> /dev/null; then
    echo -e "${RED}❌ valgrind n'est pas installé. Installe-le avec:${RESET}"
    echo "  sudo apt install valgrind   # Ubuntu/Debian"
    echo "  brew install valgrind       # Mac"
    exit 1
fi

# Fonction pour tester les fuites
test_leaks() {
    local test_name="$1"
    local args="$2"
    
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${YELLOW}📋 TEST: $test_name${RESET}"
    echo -e "${BLUE}Arguments: $args${RESET}"
    
    # Exécuter valgrind et capturer la sortie
    valgrind --leak-check=full \
             --show-leak-kinds=all \
             --track-origins=yes \
             --verbose \
             --log-file=valgrind.log \
             $PROGRAM $args > /dev/null 2>&1
    
    # Analyser le résultat
    if grep -q "All heap blocks were freed -- no leaks are possible" valgrind.log; then
        echo -e "${GREEN}✅ PAS DE FUITES${RESET}"
        OK=$((OK + 1))
    else
        echo -e "${RED}❌ FUITES DÉTECTÉES !${RESET}"
        grep -E "definitely lost|indirectly lost|possibly lost" valgrind.log
        LEAKS=$((LEAKS + 1))
    fi
    
    TOTAL=$((TOTAL + 1))
    rm -f valgrind.log
}

# =============================================================================
# DÉBUT DES TESTS
# =============================================================================

echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "${MAGENTA}         TESTEUR DE FUITES MÉMOIRE PUSH_SWAP${RESET}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"

# -----------------------------------------------------------------------------
# 1. TESTS DE PARSING (CAS NORMAUX)
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 1. TESTS DE PARSING - CAS NORMAUX ══════════════${RESET}"

test_leaks "1 nombre" "42"
test_leaks "5 nombres simples" "12 45 -7 89 0"
test_leaks "Avec zéro" "0 1 2 3 4"
test_leaks "Nombres négatifs" "-5 -3 -1 -4 -2"
test_leaks "Mix positif/négatif" "-10 5 -20 15 -30"
test_leaks "Limite INT_MAX" "2147483647"
test_leaks "Limite INT_MIN" "-2147483648"
test_leaks "Avec signe +" "+1 +2 +3 +4 +5"

# -----------------------------------------------------------------------------
# 2. TESTS DE SPLIT (ARGUMENTS GROUPÉS)
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 2. TESTS DE SPLIT ══════════════${RESET}"

test_leaks "Un argument avec espaces" "\"12 45 -7 89 0\""
test_leaks "Mix arguments simples/groupés" "12 \"45 -7\" 89 0"
test_leaks "Plusieurs groupes" "\"1 2\" \"3 4\" \"5 6\""
test_leaks "Groupes avec négatifs" "\"-1 -2\" \"-3 -4\""

# -----------------------------------------------------------------------------
# 3. TESTS D'ERREUR (DOIVENT ÉCHOUER SANS FUITES)
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 3. TESTS D'ERREUR ══════════════${RESET}"

# Doublons
test_leaks "Doublon simple" "42 21 42"
test_leaks "Doublons multiples" "5 5 5 5"
test_leaks "Doublon avec limites" "2147483647 42 2147483647"
test_leaks "Doublon négatif" "-5 -3 -5"

# Overflow
test_leaks "Overflow positif" "2147483648"
test_leaks "Overflow négatif" "-2147483649"
test_leaks "Très grand nombre" "9999999999"

# Caractères invalides
test_leaks "Lettre dans nombre" "12a 45"
test_leaks "Lettre seule" "a"
test_leaks "Caractère spécial" "12- 45"
test_leaks "Double signe" "--12 45"
test_leaks "Signe seul" "- 45"
test_leaks "Signe à la fin" "45-"
test_leaks "Chaîne vide" "\"\""
test_leaks "Espace seulement" "\" \""

# Cas limites
test_leaks "Aucun argument" ""
test_leaks "Nombre valide + invalide" "42 12a"
test_leaks "Invalide + valide" "12a 42"
test_leaks "Mélange valide/invalide" "1 2a 3"

# -----------------------------------------------------------------------------
# 4. TESTS DE TRI - PETITES PILES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 4. TESTS DE TRI - PETITES PILES ══════════════${RESET}"

# 2 nombres
test_leaks "2 nombres - déjà trié" "1 2"
test_leaks "2 nombres - à trier" "2 1"

# 3 nombres (tous les cas)
test_leaks "3 nombres - déjà trié" "1 2 3"
test_leaks "3 nombres - 3-2-1" "3 2 1"
test_leaks "3 nombres - 2-3-1" "2 3 1"
test_leaks "3 nombres - 3-1-2" "3 1 2"
test_leaks "3 nombres - 1-3-2" "1 3 2"
test_leaks "3 nombres - 2-1-3" "2 1 3"

# 4 nombres
test_leaks "4 nombres - déjà trié" "1 2 3 4"
test_leaks "4 nombres - décroissant" "4 3 2 1"
test_leaks "4 nombres - aléatoire 1" "2 4 1 3"
test_leaks "4 nombres - aléatoire 2" "3 1 4 2"

# 5 nombres
test_leaks "5 nombres - déjà trié" "1 2 3 4 5"
test_leaks "5 nombres - décroissant" "5 4 3 2 1"
test_leaks "5 nombres - aléatoire 1" "2 5 3 1 4"
test_leaks "5 nombres - aléatoire 2" "5 2 1 4 3"

# -----------------------------------------------------------------------------
# 5. TESTS DE TRI - MOYENNES PILES
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 5. TESTS DE TRI - MOYENNES PILES ══════════════${RESET}"

test_leaks "10 nombres - aléatoire" "5 2 8 1 9 3 7 4 6 10"
test_leaks "10 nombres - décroissant" "10 9 8 7 6 5 4 3 2 1"
test_leaks "20 nombres - aléatoire" "12 5 8 19 2 15 7 4 11 3 18 9 1 14 6 17 10 13 16 20"

# -----------------------------------------------------------------------------
# 6. TESTS DE TRI - GRANDES PILES (Radix)
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 6. TESTS DE TRI - GRANDES PILES ══════════════${RESET}"

# 50 nombres aléatoires
test_leaks "50 nombres - aléatoire #1" "$(seq -25 25 | shuf | head -50 | tr '\n' ' ')"
test_leaks "50 nombres - aléatoire #2" "$(seq -25 25 | shuf | head -50 | tr '\n' ' ')"

# 100 nombres aléatoires
test_leaks "100 nombres - aléatoire #1" "$(seq -50 50 | shuf | head -100 | tr '\n' ' ')"
test_leaks "100 nombres - aléatoire #2" "$(seq -50 50 | shuf | head -100 | tr '\n' ' ')"

# -----------------------------------------------------------------------------
# 7. TESTS SPÉCIAUX
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 7. TESTS SPÉCIAUX ══════════════${RESET}"

test_leaks "Grands nombres sans overflow" "1000000 2000000 3000000"
test_leaks "Nombres consécutifs" "1 2 3 4 5 6 7 8 9 10"
test_leaks "Nombres avec zéro" "0 -0 +0"
test_leaks "Un seul argument avec espaces" "\"42 21 84\""

# -----------------------------------------------------------------------------
# 8. TEST DE STRESS
# -----------------------------------------------------------------------------
echo -e "\n${CYAN}══════════════ 8. TEST DE STRESS ══════════════${RESET}"

# 500 nombres
test_leaks "500 nombres - stress test" "$(seq -250 250 | shuf | head -500 | tr '\n' ' ')"

# =============================================================================
# RÉSULTATS FINAUX
# =============================================================================

echo -e "\n${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "${MAGENTA}                     RÉSULTATS DES TESTS${RESET}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}"
echo -e "Tests sans fuites: ${GREEN}$OK${RESET} / $TOTAL"
echo -e "Tests avec fuites: ${RED}$LEAKS${RESET} / $TOTAL"

if [ $LEAKS -eq 0 ]; then
    echo -e "${GREEN}✅ PARFAIT ! Aucune fuite mémoire détectée !${RESET}"
else
    echo -e "${RED}❌ $LEAKS test(s) avec fuites mémoire. Vérifie les logs valgrind.${RESET}"
fi

echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${RESET}\n"