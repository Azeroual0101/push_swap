#!/bin/bash

# =============================================================================
# PUSH_SWAP COMPLETE TESTER
# Teste la logique, les performances et calcule le pourcentage
# =============================================================================

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
PUSH_SWAP="./push_swap"
CHECKER="./checker"
TOTAL_TESTS=0
PASSED=0
FAILED=0
TOTAL_MOVES_100=0
TOTAL_MOVES_500=0
COUNT_100=0
COUNT_500=0

# Vérification
if [ ! -f "$PUSH_SWAP" ]; then
    echo -e "${RED}❌ push_swap not found!${NC}"
    exit 1
fi

if [ ! -f "$CHECKER" ]; then
    CHECKER="./checker_linux"
fi
if [ ! -f "$CHECKER" ]; then
    CHECKER="./checker_Mac"
fi
if [ ! -f "$CHECKER" ]; then
    echo -e "${YELLOW}⚠ Checker not found. Will only count moves.${NC}"
    CHECKER=""
fi

# -----------------------------------------------------------------------------
# FONCTION DE TEST
# -----------------------------------------------------------------------------
test_case() {
    local name="$1"
    local args="$2"
    local expected="$3"
    local max_moves="$4"
    local size="$5"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📋 TEST #$TOTAL_TESTS: $name${NC}"
    echo -e "${WHITE}Arguments: $args${NC}"
    
    # Exécuter push_swap
    moves_output=$($PUSH_SWAP $args 2>&1)
    exit_code=$?
    move_count=$(echo "$moves_output" | grep -c "^[spra]")
    
    # Vérifier le code de retour
    if [ "$expected" == "ERROR" ]; then
        if [ $exit_code -ne 0 ] || [[ "$moves_output" == *"Error"* ]]; then
            echo -e "${GREEN}  ✅ Error detected correctly${NC}"
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}  ❌ Should error but didn't${NC}"
            FAILED=$((FAILED + 1))
        fi
        return
    fi
    
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}  ❌ Program crashed (exit code: $exit_code)${NC}"
        FAILED=$((FAILED + 1))
        return
    fi
    
    # Vérifier avec checker
    if [ -n "$CHECKER" ]; then
        if [ "$expected" == "EMPTY" ]; then
            if [ -z "$moves_output" ]; then
                echo -e "${GREEN}  ✅ Already sorted (0 moves)${NC}"
                PASSED=$((PASSED + 1))
            else
                echo -e "${RED}  ❌ Should be empty but got ${move_count} moves${NC}"
                FAILED=$((FAILED + 1))
            fi
        else
            checker_result=$(echo "$moves_output" | $CHECKER $args 2>&1)
            if [ "$checker_result" == "OK" ]; then
                # Calcul du pourcentage selon la taille
                if [ "$size" == "100" ]; then
                    TOTAL_MOVES_100=$((TOTAL_MOVES_100 + move_count))
                    COUNT_100=$((COUNT_100 + 1))
                    
                    if [ $move_count -le 700 ]; then
                        grade="${GREEN}100%${NC}"
                    elif [ $move_count -le 900 ]; then
                        grade="${GREEN}90%${NC}"
                    elif [ $move_count -le 1100 ]; then
                        grade="${YELLOW}80%${NC}"
                    elif [ $move_count -le 1300 ]; then
                        grade="${YELLOW}70%${NC}"
                    elif [ $move_count -le 1500 ]; then
                        grade="${RED}60%${NC}"
                    else
                        grade="${RED}50%${NC}"
                    fi
                    
                    echo -e "  ${GREEN}✅ OK${NC} - ${move_count} moves ${grade}"
                    
                elif [ "$size" == "500" ]; then
                    TOTAL_MOVES_500=$((TOTAL_MOVES_500 + move_count))
                    COUNT_500=$((COUNT_500 + 1))
                    
                    if [ $move_count -le 5500 ]; then
                        grade="${GREEN}100%${NC}"
                    elif [ $move_count -le 7000 ]; then
                        grade="${GREEN}90%${NC}"
                    elif [ $move_count -le 8500 ]; then
                        grade="${YELLOW}80%${NC}"
                    elif [ $move_count -le 10000 ]; then
                        grade="${YELLOW}70%${NC}"
                    elif [ $move_count -le 11500 ]; then
                        grade="${RED}60%${NC}"
                    else
                        grade="${RED}50%${NC}"
                    fi
                    
                    echo -e "  ${GREEN}✅ OK${NC} - ${move_count} moves ${grade}"
                else
                    # Pour les petites tailles, juste vérifier la limite
                    if [ $max_moves -gt 0 ] && [ $move_count -gt $max_moves ]; then
                        echo -e "  ${YELLOW}⚠ OK but too many moves: $move_count > $max_moves${NC}"
                    else
                        echo -e "  ${GREEN}✅ OK - ${move_count} moves${NC}"
                    fi
                fi
                
                PASSED=$((PASSED + 1))
                
            else
                echo -e "${RED}  ❌ Checker: $checker_result${NC}"
                FAILED=$((FAILED + 1))
            fi
        fi
    else
        echo -e "  ${WHITE}Moves: $move_count${NC}"
        PASSED=$((PASSED + 1))
    fi
}

# =============================================================================
# CATÉGORIE 1: TESTS DE BASE
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CATEGORY 1: BASIC TESTS ═══════════════════${NC}"

test_case "No arguments" "" "EMPTY" 0
test_case "Single number" "42" "EMPTY" 0
test_case "Two numbers sorted" "1 2" "EMPTY" 0
test_case "Two numbers unsorted" "2 1" "OK" 1
test_case "Three numbers sorted" "1 2 3" "EMPTY" 0
test_case "Three numbers reverse" "3 2 1" "OK" 3

# =============================================================================
# CATÉGORIE 2: TESTS D'ERREURS
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CATEGORY 2: ERROR TESTS ═══════════════════${NC}"

test_case "Letter in argument" "12a" "ERROR" 0
test_case "Special char" "12@" "ERROR" 0
test_case "Double sign" "--12" "ERROR" 0
test_case "Sign only" "-" "ERROR" 0
test_case "Overflow" "2147483648" "ERROR" 0
test_case "Underflow" "-2147483649" "ERROR" 0
test_case "Duplicate" "42 42" "ERROR" 0

# =============================================================================
# CATÉGORIE 3: PETITES PILES
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CATEGORY 3: SMALL STACKS ═══════════════════${NC}"

test_case "2 numbers" "2 1" "OK" 1
test_case "3 numbers (2-3-1)" "2 3 1" "OK" 3
test_case "3 numbers (3-1-2)" "3 1 2" "OK" 3
test_case "4 numbers" "4 2 1 3" "OK" 8
test_case "5 numbers" "3 1 5 2 4" "OK" 12

# =============================================================================
# CATÉGORIE 4: 100 NOMBRES (10 TESTS)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CATEGORY 4: 100 NUMBERS ═══════════════════${NC}"

for i in {1..10}; do
    ARG=$(shuf -i 1-1000 -n 100 | tr '\n' ' ')
    test_case "100 random #$i" "$ARG" "OK" 1100 "100"
done

# =============================================================================
# CATÉGORIE 5: 500 NOMBRES (5 TESTS)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CATEGORY 5: 500 NUMBERS ═══════════════════${NC}"

for i in {1..5}; do
    ARG=$(shuf -i 1-5000 -n 500 | tr '\n' ' ')
    test_case "500 random #$i" "$ARG" "OK" 8500 "500"
done

# =============================================================================
# RÉSULTATS ET ANALYSE DE PERFORMANCE
# =============================================================================
echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${MAGENTA}                         FINAL RESULTS                         ${CYAN}║${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  Total tests:   ${WHITE}$TOTAL_TESTS${NC}"
echo -e "${CYAN}║${NC}  Passed:        ${GREEN}$PASSED${NC}"
echo -e "${CYAN}║${NC}  Failed:        ${RED}$FAILED${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"

# Analyse pour 100 nombres
if [ $COUNT_100 -gt 0 ]; then
    AVG_100=$((TOTAL_MOVES_100 / COUNT_100))
    PERCENT_100=0
    
    if [ $AVG_100 -le 700 ]; then
        PERCENT_100=100
        GRADE_100="${GREEN}100%${NC}"
    elif [ $AVG_100 -le 900 ]; then
        PERCENT_100=90
        GRADE_100="${GREEN}90%${NC}"
    elif [ $AVG_100 -le 1100 ]; then
        PERCENT_100=80
        GRADE_100="${YELLOW}80%${NC}"
    elif [ $AVG_100 -le 1300 ]; then
        PERCENT_100=70
        GRADE_100="${YELLOW}70%${NC}"
    elif [ $AVG_100 -le 1500 ]; then
        PERCENT_100=60
        GRADE_100="${RED}60%${NC}"
    else
        PERCENT_100=50
        GRADE_100="${RED}50%${NC}"
    fi
    
    echo -e "${CYAN}║${NC}  ${WHITE}100 NUMBERS PERFORMANCE${NC}"
    echo -e "${CYAN}║${NC}    Tests:      $COUNT_100"
    echo -e "${CYAN}║${NC}    Average:    $AVG_100 moves"
    echo -e "${CYAN}║${NC}    Grade:      $GRADE_100"
fi

# Analyse pour 500 nombres
if [ $COUNT_500 -gt 0 ]; then
    AVG_500=$((TOTAL_MOVES_500 / COUNT_500))
    PERCENT_500=0
    
    if [ $AVG_500 -le 5500 ]; then
        PERCENT_500=100
        GRADE_500="${GREEN}100%${NC}"
    elif [ $AVG_500 -le 7000 ]; then
        PERCENT_500=90
        GRADE_500="${GREEN}90%${NC}"
    elif [ $AVG_500 -le 8500 ]; then
        PERCENT_500=80
        GRADE_500="${YELLOW}80%${NC}"
    elif [ $AVG_500 -le 10000 ]; then
        PERCENT_500=70
        GRADE_500="${YELLOW}70%${NC}"
    elif [ $AVG_500 -le 11500 ]; then
        PERCENT_500=60
        GRADE_500="${RED}60%${NC}"
    else
        PERCENT_500=50
        GRADE_500="${RED}50%${NC}"
    fi
    
    echo -e "${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${WHITE}500 NUMBERS PERFORMANCE${NC}"
    echo -e "${CYAN}║${NC}    Tests:      $COUNT_500"
    echo -e "${CYAN}║${NC}    Average:    $AVG_500 moves"
    echo -e "${CYAN}║${NC}    Grade:      $GRADE_500"
fi

echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"

# Conclusion
if [ $FAILED -eq 0 ]; then
    if [ $PERCENT_100 -ge 80 ] && [ $PERCENT_500 -ge 80 ]; then
        echo -e "${CYAN}║${NC}  ${GREEN}🎉 EXCELLENT! Ton radix est à 80%+ 🎉${NC}"
        echo -e "${CYAN}║${NC}  ${GREEN}Logique parfaite, performances solides${NC}"
    elif [ $PERCENT_100 -ge 80 ]; then
        echo -e "${CYAN}║${NC}  ${YELLOW}⚠ Bon pour 100, à optimiser pour 500${NC}"
    else
        echo -e "${CYAN}║${NC}  ${YELLOW}⚠ Performances à améliorer${NC}"
    fi
else
    echo -e "${CYAN}║${NC}  ${RED}❌ Des erreurs de logique persistent${NC}"
fi

echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}\n"