#!/bin/bash

# =============================================================================
# PUSH_SWAP ULTRA HARD TESTER avec CHECKER
# by: abdazero (hardened version)
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

PUSH_SWAP="./push_swap"
CHECKER="./checker"
if [ ! -f "$CHECKER" ]; then CHECKER="./checker"; fi
if [ ! -f "$CHECKER" ]; then CHECKER="./checker_Mac"; fi

TOTAL=0
PASSED=0
FAILED=0
INVALID=0
DETAILS=()

if [ ! -f "$PUSH_SWAP" ]; then
    echo -e "${RED}❌ push_swap not found!${NC}"; exit 1
fi

if [ ! -f "$CHECKER" ]; then
    echo -e "${YELLOW}⚠ Checker not found! Move counting only.${NC}"
    CHECKER=""
else
    echo -e "${GREEN}✓ Checker: $CHECKER${NC}"
fi

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${MAGENTA}           PUSH_SWAP ULTRA HARD TESTER WITH CHECKER              ${CYAN}║${NC}"
echo -e "${CYAN}║${BLUE}                       by: abdazero (hardened)                      ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════╝${NC}\n"

# -----------------------------------------------------------------------------
# FONCTION DE TEST
# -----------------------------------------------------------------------------
test_case() {
    local name="$1"
    local args="$2"
    local expected="$3"
    local max_moves="$4"

    TOTAL=$((TOTAL + 1))

    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📋 TEST #$TOTAL: $name${NC}"
    echo -e "${WHITE}Arguments: ${args:0:80}$([ ${#args} -gt 80 ] && echo '...')${NC}"

    # Timeout : kill si > 5 secondes
    moves_output=$(timeout 5s $PUSH_SWAP $args 2>&1)
    exit_code=$?

    if [ $exit_code -eq 124 ]; then
        echo -e "${RED}  ❌ TIMEOUT (>5s) — infinite loop or deadlock?${NC}"
        DETAILS+=("TIMEOUT  | TEST #$TOTAL: $name")
        FAILED=$((FAILED + 1))
        return
    fi

    move_count=$(echo "$moves_output" | grep -cE "^(sa|sb|ss|pa|pb|ra|rb|rr|rra|rrb|rrr)$")

    if [ "$expected" == "ERROR" ]; then
        if [ $exit_code -ne 0 ] || echo "$moves_output" | grep -q "^Error$"; then
            echo -e "${GREEN}  ✅ Error detected correctly${NC}"
            DETAILS+=("PASS     | TEST #$TOTAL: $name")
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}  ❌ Should error but didn't (output: '$moves_output')${NC}"
            DETAILS+=("FAIL     | TEST #$TOTAL: $name — no error")
            FAILED=$((FAILED + 1))
        fi
        return
    fi

    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}  ❌ Crash (exit $exit_code)${NC}"
        DETAILS+=("FAIL     | TEST #$TOTAL: $name — crash")
        FAILED=$((FAILED + 1))
        return
    fi

    # Vérifier les mouvements invalides
    invalid_moves=$(echo "$moves_output" | grep -vE "^(sa|sb|ss|pa|pb|ra|rb|rr|rra|rrb|rrr)$" | grep -v "^$")
    if [ -n "$invalid_moves" ]; then
        echo -e "${RED}  ❌ Invalid move(s) in output: $(echo "$invalid_moves" | head -3)${NC}"
        DETAILS+=("FAIL     | TEST #$TOTAL: $name — invalid moves")
        FAILED=$((FAILED + 1))
        return
    fi

    if [ -n "$CHECKER" ]; then
        if [ "$expected" == "EMPTY" ]; then
            if [ -z "$moves_output" ]; then
                echo -e "${GREEN}  ✅ Already sorted (0 moves)${NC}"
                DETAILS+=("PASS     | TEST #$TOTAL: $name")
                PASSED=$((PASSED + 1))
            else
                echo -e "${RED}  ❌ Should output nothing — got $move_count moves${NC}"
                DETAILS+=("FAIL     | TEST #$TOTAL: $name — should be 0 moves")
                FAILED=$((FAILED + 1))
            fi
        else
            if [ -z "$moves_output" ]; then
                # Vérifier que c'est vraiment déjà trié
                first=$(echo $args | tr ' ' '\n' | head -1)
                # Accept empty if it seems sorted — let checker confirm
                checker_result=$(echo "" | $CHECKER $args 2>&1)
                if [ "$checker_result" == "OK" ]; then
                    echo -e "${GREEN}  ✅ Already sorted (0 moves)${NC}"
                    DETAILS+=("PASS     | TEST #$TOTAL: $name")
                    PASSED=$((PASSED + 1))
                else
                    echo -e "${RED}  ❌ No moves but not sorted${NC}"
                    DETAILS+=("FAIL     | TEST #$TOTAL: $name — no moves, unsorted")
                    FAILED=$((FAILED + 1))
                fi
            else
                checker_result=$(echo "$moves_output" | timeout 5s $CHECKER $args 2>&1)
                if [ "$checker_result" == "OK" ]; then
                    if [ $max_moves -gt 0 ] && [ $move_count -gt $max_moves ]; then
                        echo -e "${YELLOW}  ⚠ SORTED but too many moves: $move_count > $max_moves${NC}"
                        DETAILS+=("INVALID  | TEST #$TOTAL: $name — $move_count moves (max $max_moves)")
                        INVALID=$((INVALID + 1))
                    else
                        echo -e "${GREEN}  ✅ OK — $move_count moves${NC}"
                        DETAILS+=("PASS     | TEST #$TOTAL: $name — $move_count moves")
                        PASSED=$((PASSED + 1))
                    fi
                else
                    echo -e "${RED}  ❌ Checker: $checker_result${NC}"
                    DETAILS+=("FAIL     | TEST #$TOTAL: $name — checker KO")
                    FAILED=$((FAILED + 1))
                fi
            fi
        fi
    else
        # Sans checker: signaler si dépasse la limite
        if [ $max_moves -gt 0 ] && [ $move_count -gt $max_moves ]; then
            echo -e "  ${YELLOW}⚠ $move_count moves (limit: $max_moves) — no checker to verify sort${NC}"
            DETAILS+=("INVALID  | TEST #$TOTAL: $name — $move_count moves > $max_moves (no checker)")
            INVALID=$((INVALID + 1))
        else
            echo -e "  ${WHITE}Moves: $move_count${NC} (no checker)"
            DETAILS+=("PASS     | TEST #$TOTAL: $name — $move_count moves (unverified, no checker)")
            PASSED=$((PASSED + 1))
        fi
    fi
}

# Fonction pour statistiques sur N runs identiques
stress_test() {
    local name="$1"
    local size="$2"
    local max_moves="$3"
    local runs="$4"

    echo -e "\n${MAGENTA}🔁 STRESS: $name ($runs runs, max $max_moves moves each)${NC}"
    local s_pass=0 s_fail=0 s_inv=0 total_moves=0 max_seen=0

    for i in $(seq 1 $runs); do
        local args=$(shuf -i 1-$((size * 10)) -n $size | tr '\n' ' ')
        TOTAL=$((TOTAL + 1))
        local out=$(timeout 5s $PUSH_SWAP $args 2>&1)
        local ec=$?
        local cnt=$(echo "$out" | grep -cE "^(sa|sb|ss|pa|pb|ra|rb|rr|rra|rrb|rrr)$")
        total_moves=$((total_moves + cnt))
        [ $cnt -gt $max_seen ] && max_seen=$cnt
        if [ $ec -eq 124 ]; then
            echo -e "  ${RED}#$i TIMEOUT${NC}"
            FAILED=$((FAILED + 1)); s_fail=$((s_fail + 1)); continue
        fi
        if [ -n "$CHECKER" ]; then
            local cr=$(echo "$out" | timeout 5s $CHECKER $args 2>&1)
            if [ "$cr" == "OK" ]; then
                if [ $cnt -gt $max_moves ]; then
                    s_inv=$((s_inv + 1)); INVALID=$((INVALID + 1))
                    DETAILS+=("INVALID  | STRESS $name #$i — $cnt moves (max $max_moves)")
                else
                    s_pass=$((s_pass + 1)); PASSED=$((PASSED + 1))
                fi
            else
                s_fail=$((s_fail + 1)); FAILED=$((FAILED + 1))
                echo -e "  ${RED}#$i FAIL (checker KO, moves=$cnt)${NC}"
                DETAILS+=("FAIL     | STRESS $name #$i — checker KO")
            fi
        else
            # Sans checker: signaler si dépasse la limite
            if [ $cnt -gt $max_moves ]; then
                s_inv=$((s_inv + 1)); INVALID=$((INVALID + 1))
                DETAILS+=("INVALID  | STRESS $name #$i — $cnt moves > $max_moves (no checker)")
            else
                s_pass=$((s_pass + 1)); PASSED=$((PASSED + 1))
            fi
        fi
    done
    local avg=$(( runs > 0 ? total_moves / runs : 0 ))
    echo -e "  Results: ${GREEN}$s_pass OK${NC} | ${RED}$s_fail FAIL${NC} | ${YELLOW}$s_inv TOO MANY${NC}"
    echo -e "  Moves — avg: ${WHITE}$avg${NC} | max seen: ${WHITE}$max_seen${NC} | limit: ${WHITE}$max_moves${NC}"
}

# =============================================================================
# CATÉGORIE 1: TESTS DE BASE
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 1: BASIC TESTS ═══════════════════${NC}"

test_case "No arguments"         ""          "EMPTY" 0
test_case "Single number"        "42"        "EMPTY" 0
test_case "Two sorted"           "1 2"       "EMPTY" 0
test_case "Two unsorted"         "2 1"       "OK"    1
test_case "Three sorted"         "1 2 3"     "EMPTY" 0
test_case "Three reverse"        "3 2 1"     "OK"    3
test_case "Five sorted"          "1 2 3 4 5" "EMPTY" 0

# =============================================================================
# CATÉGORIE 2: ERREURS (beaucoup plus exhaustif)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 2: ERROR TESTS ═══════════════════${NC}"

test_case "Letter"               "abc"          "ERROR" 0
test_case "Letter in number"     "12a"          "ERROR" 0
test_case "Special char @"       "12@"          "ERROR" 0
test_case "Double sign --"       "--12"         "ERROR" 0
test_case "Double sign ++"       "++12"         "ERROR" 0
test_case "Plus and minus"       "+-12"         "ERROR" 0
test_case "Sign only -"          "-"            "ERROR" 0
test_case "Sign only +"          "+"            "ERROR" 0
test_case "Empty string arg"     "''"           "ERROR" 0
test_case "Space only arg"       "' '"          "ERROR" 0
test_case "Overflow +1"          "2147483648"   "ERROR" 0
test_case "Underflow -1"         "-2147483649"  "ERROR" 0
test_case "Big overflow"         "9999999999"   "ERROR" 0
test_case "Big underflow"        "-9999999999"  "ERROR" 0
test_case "Dup simple"           "1 2 3 2 4"    "ERROR" 0
test_case "Dup with +"           "5 +5"         "ERROR" 0
test_case "Dup negatives"        "-3 0 -3"      "ERROR" 0
test_case "Float number"         "3.14"         "ERROR" 0
test_case "Number with spaces"   "1  2"         "ERROR" 0
test_case "Zero dup"             "0 1 2 0"      "ERROR" 0
test_case "Overflow with +"      "+2147483648"  "ERROR" 0
test_case "Tab in arg"           $'1\t2'        "ERROR" 0

# =============================================================================
# CATÉGORIE 3: PETITES PILES — limites STRICTES
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 3: SMALL STACKS (strict limits) ═══════════════════${NC}"

test_case "2 nums"               "2 1"             "OK" 1
test_case "3 (2 3 1)"            "2 3 1"           "OK" 2
test_case "3 (3 1 2)"            "3 1 2"           "OK" 2
test_case "3 (1 3 2)"            "1 3 2"           "OK" 2
test_case "3 (3 2 1)"            "3 2 1"           "OK" 3
test_case "4 ascending rot"      "2 3 4 1"         "OK" 8
test_case "4 random 1"           "4 2 1 3"         "OK" 8
test_case "4 random 2"           "3 4 1 2"         "OK" 8
test_case "4 reverse"            "4 3 2 1"         "OK" 8
test_case "5 random 1"           "3 1 5 2 4"       "OK" 12
test_case "5 random 2"           "5 1 4 2 3"       "OK" 12
test_case "5 reverse"            "5 4 3 2 1"       "OK" 12
test_case "5 one off"            "1 2 3 5 4"       "OK" 12

# Tous les cas de 3 éléments (permutations avec {1,2,3})
for perm in "1 3 2" "2 1 3" "2 3 1" "3 1 2" "3 2 1"; do
    test_case "3-perm ($perm)" "$perm" "OK" 3
done

# =============================================================================
# CATÉGORIE 4: BORNES INT (edge values)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 4: INT BOUNDARY VALUES ═══════════════════${NC}"

test_case "INT_MIN alone"        "-2147483648"                          "EMPTY" 0
test_case "INT_MAX alone"        "2147483647"                           "EMPTY" 0
test_case "INT_MIN INT_MAX"      "-2147483648 2147483647"               "EMPTY" 0
test_case "INT_MAX INT_MIN"      "2147483647 -2147483648"               "OK"    1
test_case "MIN MID MAX"          "-2147483648 0 2147483647"             "EMPTY" 0
test_case "MAX MID MIN"          "2147483647 0 -2147483648"             "OK"    3
test_case "+0 valid"             "+0"                                   "EMPTY" 0
test_case "0 only"               "0"                                    "EMPTY" 0
test_case "Negatives only"       "-5 -3 -1 -10 -7"                     "OK"    12
test_case "Mixed large range"    "-2147483648 -1 0 1 2147483647"        "EMPTY" 0
test_case "Mixed unsorted"       "2147483647 -2147483648 0 -1 1"       "OK"    12

# =============================================================================
# CATÉGORIE 5: PILES MOYENNES — limites STRICTES (42 école)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 5: MEDIUM STACKS (strict 42 limits) ═══════════════════${NC}"

# 42 school grading: 100 numbers < 700 ops, 500 numbers < 5500 ops
test_case "10 sorted"    "$(seq 1 10 | tr '\n' ' ')"       "EMPTY" 0
test_case "10 reverse"   "$(seq 10 -1 1 | tr '\n' ' ')"   "OK"    50

for i in {1..5}; do
    test_case "20 random #$i"  "$(shuf -i 1-200 -n 20 | tr '\n' ' ')"   "OK" 100
done

for i in {1..5}; do
    test_case "50 random #$i"  "$(shuf -i 1-500 -n 50 | tr '\n' ' ')"   "OK" 350
done

# =============================================================================
# CATÉGORIE 6: GRANDES PILES — limites STRICTES (notation 42)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 6: LARGE STACKS (42 grading limits) ═══════════════════${NC}"

# 100 nums: 5pts=700, 4pts=900, 3pts=1100, 2pts=1300, 1pt=1500 (strict: <=700 for full)
for i in {1..10}; do
    test_case "100 random #$i"  "$(shuf -i 1-1000 -n 100 | tr '\n' ' ')"   "OK"  700
done

# 500 nums: 5pts=5500, 4pts=7000, 3pts=8500, 2pts=10000, 1pt=11500
for i in {1..5}; do
    test_case "500 random #$i"  "$(shuf -i 1-5000 -n 500 | tr '\n' ' ')"   "OK"  5500
done

# =============================================================================
# CATÉGORIE 7: CAS SPÉCIAUX / PIÈGES
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 7: SPECIAL / TRICKY CASES ═══════════════════${NC}"

test_case "Already sorted 100"   "$(seq 1 100 | tr '\n' ' ')"          "EMPTY" 0
test_case "Reverse sorted 100"   "$(seq 100 -1 1 | tr '\n' ' ')"       "OK"    1500
test_case "All same sign neg 5"  "-5 -4 -3 -2 -1"                      "EMPTY" 0
test_case "All same sign neg rev" "-1 -2 -3 -4 -5"                     "OK"    12
test_case "One number off end"   "2 3 4 5 1"                           "OK"    12
test_case "One number off start" "5 1 2 3 4"                           "OK"    12
test_case "Interleaved"          "1 3 5 7 2 4 6 8"                     "OK"    30
test_case "Duplicated range neg" "-3 -1 -4 -2 -5"                      "OK"    12
test_case "10 consecutive rev"   "10 9 8 7 6 5 4 3 2 1"                "OK"    35
test_case "Pyramid"              "5 1 4 2 3"                           "OK"    12
test_case "With +sign prefix"    "+3 +1 +2"                            "OK"    3
test_case "Mix + and no prefix"  "+10 5 -3 +1 0"                       "OK"    12
test_case "200 random"           "$(shuf -i 1-2000 -n 200 | tr '\n' ' ')" "OK" 2000

# =============================================================================
# CATÉGORIE 8: STRESS TESTS (repeated random, statistiques)
# =============================================================================
echo -e "\n${CYAN}═══════════════════ CAT 8: STRESS TESTS ═══════════════════${NC}"

stress_test "5 numbers"    5    12    50
stress_test "100 numbers" 100  700   20
stress_test "500 numbers" 500  5500  10

# =============================================================================
# RÉSUMÉ DÉTAILLÉ
# =============================================================================
echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${MAGENTA}                        FINAL RESULTS                              ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  Total:    ${WHITE}$TOTAL${NC}"
echo -e "${CYAN}║${NC}  Passed:   ${GREEN}$PASSED${NC}"
echo -e "${CYAN}║${NC}  Failed:   ${RED}$FAILED${NC}"
echo -e "${CYAN}║${NC}  Invalid:  ${YELLOW}$INVALID${NC} (sorted but too many moves)"
echo -e "${CYAN}║${NC}"

# Afficher uniquement FAIL et INVALID
echo -e "${CYAN}║${YELLOW}  Issues (FAIL / TOO MANY MOVES only):${NC}"
SHOWN=0
for d in "${DETAILS[@]}"; do
    if [[ "$d" == FAIL* ]]; then
        echo -e "${CYAN}║${NC}    ${RED}❌ $d${NC}"
        SHOWN=$((SHOWN + 1))
    elif [[ "$d" == INVALID* ]]; then
        echo -e "${CYAN}║${NC}    ${YELLOW}⚠ $d${NC}"
        SHOWN=$((SHOWN + 1))
    fi
done
[ $SHOWN -eq 0 ] && echo -e "${CYAN}║${NC}    ${GREEN}(none — all issues resolved)${NC}"

# Note si pas de checker
if [ -z "$CHECKER" ]; then
    echo -e "${CYAN}║${NC}"
    echo -e "${CYAN}║${YELLOW}  ⚠ No checker found — sorting correctness NOT verified${NC}"
    echo -e "${CYAN}║${NC}    ${WHITE}Put checker / checker_linux / checker_Mac next to push_swap${NC}"
fi

echo -e "${CYAN}║${NC}"
if [ $FAILED -eq 0 ] && [ $INVALID -eq 0 ]; then
    echo -e "${CYAN}║${NC}  ${GREEN}🎉 PERFECT — ALL TESTS PASSED WITH STRICT LIMITS! 🎉${NC}"
elif [ $FAILED -eq 0 ]; then
    echo -e "${CYAN}║${NC}  ${YELLOW}⚠ All sorts correct but some exceed move limits${NC}"
else
    echo -e "${CYAN}║${NC}  ${RED}❌ Some tests failed — see issues above${NC}"
fi
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}\n"

exit $FAILED