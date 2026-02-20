#!/bin/bash

# PUSH_SWAP EXTREME TORTURE TEST SUITE
# This will absolutely destroy any weak implementation
# Testing every edge case, boundary, and nightmare scenario

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

PUSH_SWAP="./push_swap"
CHECKER="./checker"

if [ ! -f "$PUSH_SWAP" ]; then
    echo -e "${RED}Error: push_swap not found!${NC}"
    exit 1
fi

USE_CHECKER=false
if [ -f "$CHECKER" ]; then
    USE_CHECKER=true
    echo -e "${GREEN}✓ Checker found! Will verify sorting for valid inputs.${NC}"
else
    echo -e "${YELLOW}⚠ Checker not found. Will skip sorting verification.${NC}"
fi

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
LEAK_TESTS=0
LEAK_FAILS=0

print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${MAGENTA}          PUSH_SWAP EXTREME TORTURE TEST SUITE                ${CYAN}║${NC}"
    echo -e "${CYAN}║${BLUE}          by : abdesala                                         ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
}

print_category() {
    echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}>>> $1${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

check_leaks() {
    local args="$1"
    local test_num="$2"
    
    if ! command -v valgrind &> /dev/null; then
        return 0
    fi
    
    LEAK_TESTS=$((LEAK_TESTS + 1))
    
    valgrind_output=$(valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --error-exitcode=42 $PUSH_SWAP $args 2>&1)
    valgrind_exit=$?
    
    if echo "$valgrind_output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
        echo -e "    ${GREEN}✓ No leaks${NC}"
        return 0
    elif echo "$valgrind_output" | grep -q "definitely lost: 0 bytes in 0 blocks" && \
         echo "$valgrind_output" | grep -q "indirectly lost: 0 bytes in 0 blocks" && \
         echo "$valgrind_output" | grep -q "possibly lost: 0 bytes in 0 blocks"; then
        echo -e "    ${GREEN}✓ No leaks${NC}"
        return 0
    else
        LEAK_FAILS=$((LEAK_FAILS + 1))
        echo -e "    ${RED}✗ MEMORY LEAK DETECTED!${NC}"
        echo "$valgrind_output" | grep -A 5 "LEAK SUMMARY"
        return 1
    fi
}

test_case() {
    local description="$1"
    local args="$2"
    local expected="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    result=$(eval "$PUSH_SWAP $args" 2>&1)
    exit_code=$?
    
    if [ "$expected" == "ERROR" ]; then
        if [ "$result" == "Error" ] || [ $exit_code -ne 0 ]; then
            echo -e "${GREEN}✓${NC} Test #$TOTAL_TESTS: $description"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            check_leaks "$args" "$TOTAL_TESTS"
        else
            echo -e "${RED}✗${NC} Test #$TOTAL_TESTS: $description"
            echo -e "  Expected: Error, Got: '$result'"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    elif [ "$expected" == "EMPTY" ]; then
        if [ -z "$result" ] && [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}✓${NC} Test #$TOTAL_TESTS: $description"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            check_leaks "$args" "$TOTAL_TESTS"
        else
            echo -e "${RED}✗${NC} Test #$TOTAL_TESTS: $description"
            echo -e "  Expected: Nothing (already sorted), Got: '$result'"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    else
        # Valid case - check if it works and optionally verify with checker
        if [ $exit_code -eq 0 ]; then
            if [ "$USE_CHECKER" = true ] && [ -n "$result" ]; then
                checker_result=$(echo "$result" | eval "$CHECKER $args" 2>&1)
                if [ "$checker_result" == "OK" ]; then
                    echo -e "${GREEN}✓${NC} Test #$TOTAL_TESTS: $description ${GREEN}[Sorted correctly]${NC}"
                    PASSED_TESTS=$((PASSED_TESTS + 1))
                    check_leaks "$args" "$TOTAL_TESTS"
                else
                    echo -e "${RED}✗${NC} Test #$TOTAL_TESTS: $description ${RED}[Checker: $checker_result]${NC}"
                    FAILED_TESTS=$((FAILED_TESTS + 1))
                fi
            else
                echo -e "${GREEN}✓${NC} Test #$TOTAL_TESTS: $description"
                PASSED_TESTS=$((PASSED_TESTS + 1))
                check_leaks "$args" "$TOTAL_TESTS"
            fi
        else
            echo -e "${RED}✗${NC} Test #$TOTAL_TESTS: $description ${RED}[Exit code: $exit_code]${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    fi
}

print_header

# Check for valgrind
if command -v valgrind &> /dev/null; then
    echo -e "${GREEN}✓ Valgrind found! Memory leak detection enabled!${NC}"
else
    echo -e "${YELLOW}⚠ Valgrind not found. Install it for leak detection: sudo apt-get install valgrind${NC}"
fi
echo ""

# ============================================================================
# CATEGORY 1: BASIC EDGE CASES
# ============================================================================
print_category "CATEGORY 1: BASIC EDGE CASES"

test_case "No arguments" "" "EMPTY"
test_case "Single number" "42" "EMPTY"
test_case "Two numbers already sorted" "1 2" "EMPTY"
test_case "Two numbers reverse sorted" "2 1" "VALID"
test_case "Three numbers already sorted" "1 2 3" "EMPTY"

# ============================================================================
# CATEGORY 2: WHITESPACE MADNESS
# ============================================================================
print_category "CATEGORY 2: WHITESPACE TORTURE"

test_case "Multiple spaces between numbers" "'1    2    3'" "EMPTY"
test_case "Tabs between numbers" "'1\t2\t3'" "ERROR"
test_case "Leading spaces" "'   1 2 3'" "EMPTY"
test_case "Trailing spaces" "'1 2 3   '" "EMPTY"
test_case "Mixed whitespace" "'  1  \t 2   \t\t  3  '" "ERROR"
test_case "Only spaces" "'     '" "ERROR"
test_case "Only tabs" "'\t\t\t'" "ERROR"
test_case "Spaces and tabs only" "'  \t  \t  '" "ERROR"
test_case "Newlines in string" "'1\n2\n3'" "ERROR"

# ============================================================================
# CATEGORY 3: INTEGER BOUNDARY TESTING
# ============================================================================
print_category "CATEGORY 3: INTEGER BOUNDARIES"

test_case "INT_MAX" "2147483647" "EMPTY"
test_case "INT_MIN" "-2147483648" "EMPTY"
test_case "INT_MAX + 1" "2147483648" "ERROR"
test_case "INT_MIN - 1" "-2147483649" "ERROR"
test_case "Just above INT_MAX" "2147483650" "ERROR"
test_case "Just below INT_MIN" "-2147483650" "ERROR"
test_case "Way above INT_MAX" "999999999999999" "ERROR"
test_case "Way below INT_MIN" "-999999999999999" "ERROR"
test_case "INT_MAX and INT_MIN together" "-2147483648 2147483647" "EMPTY"
test_case "Multiple boundary values" "-2147483648 0 2147483647" "EMPTY"

# ============================================================================
# CATEGORY 4: SIGN TORTURE
# ============================================================================
print_category "CATEGORY 4: SIGN VARIATIONS"

test_case "Plus sign positive" "'+5'" "EMPTY"
test_case "Multiple plus signs" "'++5'" "ERROR"
test_case "Plus and minus" "'+-5'" "ERROR"
test_case "Minus and plus" "'-+5'" "ERROR"
test_case "Double negative" "'--5'" "ERROR"
test_case "Sign without number" "'+'" "ERROR"
test_case "Multiple signs" "'+ 5'" "ERROR"
test_case "Sign in middle" "'5+5'" "ERROR"
test_case "Trailing sign" "'5+'" "ERROR"
test_case "Mixed valid signs" "'+5 -3 +0 -1'" "VALID"

# ============================================================================
# CATEGORY 5: ZERO TORTURE
# ============================================================================
print_category "CATEGORY 5: ZERO VARIATIONS"

test_case "Simple zero" "0" "EMPTY"
test_case "Positive zero" "'+0'" "EMPTY"
test_case "Negative zero" "'-0'" "EMPTY"
test_case "Leading zeros" "'007'" "EMPTY"
test_case "Multiple leading zeros" "'00000042'" "EMPTY"
test_case "Zero with plus and leading zeros" "'+00000'" "EMPTY"
test_case "Zero with minus and leading zeros" "'-00000'" "EMPTY"
test_case "Multiple different zeros" "'0 +0 -0 00 000'" "ERROR"
test_case "Leading zeros max int" "'0002147483647'" "EMPTY"
test_case "Leading zeros overflow" "'0002147483648'" "ERROR"

# ============================================================================
# CATEGORY 6: DUPLICATE DETECTION
# ============================================================================
print_category "CATEGORY 6: DUPLICATE DETECTION"

test_case "Simple duplicate" "'1 1'" "ERROR"
test_case "Duplicate with different signs" "'5 +5'" "ERROR"
test_case "Duplicate zeros" "'0 0'" "ERROR"
test_case "Duplicate with leading zeros" "'5 05'" "ERROR"
test_case "Multiple duplicates" "'1 2 3 2 1'" "ERROR"
test_case "Duplicate at boundaries" "'-2147483648 -2147483648'" "ERROR"
test_case "Hidden duplicate in large set" "'1 2 3 4 5 6 7 8 9 10 5'" "ERROR"
test_case "Duplicate zeros variations" "'0 +0'" "ERROR"
test_case "Duplicate with spacing" "'1 2 3   3 4'" "ERROR"

# ============================================================================
# CATEGORY 7: INVALID CHARACTER INJECTION
# ============================================================================
print_category "CATEGORY 7: INVALID CHARACTERS"

test_case "Letter in number" "'12a34'" "ERROR"
test_case "Letter at start" "'a123'" "ERROR"
test_case "Letter at end" "'123a'" "ERROR"
test_case "Special character" "'12@34'" "ERROR"
test_case "Underscore" "'12_34'" "ERROR"
test_case "Period/decimal" "'12.34'" "ERROR"
test_case "Comma" "'12,34'" "ERROR"
test_case "Semicolon" "'1;2;3'" "ERROR"
test_case "Colon" "'1:2:3'" "ERROR"
test_case "Slash" "'1/2/3'" "ERROR"
test_case "Backslash" "'1\2\3'" "ERROR"
test_case "Question mark" "'123?'" "ERROR"
test_case "Exclamation" "'123!'" "ERROR"
test_case "Hash/pound" "'#123'" "ERROR"
test_case "Percent" "'123%'" "ERROR"
test_case "Caret" "'123^'" "ERROR"
test_case "Ampersand" "'123&'" "ERROR"
test_case "Asterisk" "'123*'" "ERROR"
test_case "Parentheses" "'(123)'" "ERROR"
test_case "Brackets" "'[123]'" "ERROR"
test_case "Braces" "'{123}'" "ERROR"
test_case "Pipe" "'1|2|3'" "ERROR"
test_case "Tilde" "'~123'" "ERROR"
test_case "Backtick" "'\`123\`'" "ERROR"

# ============================================================================
# CATEGORY 8: ALREADY SORTED SEQUENCES
# ============================================================================
print_category "CATEGORY 8: ALREADY SORTED (Should print nothing)"

test_case "2 sorted" "'1 2'" "EMPTY"
test_case "3 sorted" "'1 2 3'" "EMPTY"
test_case "5 sorted" "'1 2 3 4 5'" "EMPTY"
test_case "10 sorted" "'1 2 3 4 5 6 7 8 9 10'" "EMPTY"
test_case "Sorted with negatives" "'-5 -3 -1 0 1 3 5'" "EMPTY"
test_case "Sorted with gaps" "'10 20 30 40 50'" "EMPTY"
test_case "Sorted large numbers" "'100 200 300 400 500'" "EMPTY"
test_case "Sorted with boundaries" "'-2147483648 0 2147483647'" "EMPTY"

# ============================================================================
# CATEGORY 9: ARGUMENT FORMAT VARIATIONS
# ============================================================================
print_category "CATEGORY 9: ARGUMENT FORMAT VARIATIONS"

test_case "Multiple arguments (valid)" "3 2 1" "VALID"
test_case "Single string argument" "'3 2 1'" "VALID"
test_case "Mixed format (should handle)" "1 '2 3' 4" "VALID"
test_case "Empty string in args" "1 '' 2" "ERROR"
test_case "NULL-like empty" "1 2 ''" "ERROR"

# ============================================================================
# CATEGORY 10: EXTREME SIZE TESTS
# ============================================================================
print_category "CATEGORY 10: EXTREME SIZE TESTS"

# Generate large sequences
large_sorted=$(seq 1 100 | tr '\n' ' ')
large_reverse=$(seq 100 -1 1 | tr '\n' ' ')
large_random=$(shuf -i 1-500 -n 500 | tr '\n' ' ')

test_case "100 numbers already sorted" "'$large_sorted'" "EMPTY"
test_case "100 numbers reverse" "'$large_reverse'" "VALID"
test_case "500 random numbers" "'$large_random'" "VALID"

# ============================================================================
# CATEGORY 11: EVIL OVERFLOW ATTEMPTS
# ============================================================================
print_category "CATEGORY 11: OVERFLOW ATTACKS"

test_case "Long number string" "'12345678901234567890'" "ERROR"
test_case "Leading zeros overflow" "'000002147483648'" "ERROR"
test_case "Positive overflow by 1" "'2147483648'" "ERROR"
test_case "Negative overflow by 1" "'-2147483649'" "ERROR"
test_case "Scientific notation" "'1e10'" "ERROR"
test_case "Hexadecimal" "'0x1F'" "ERROR"
test_case "Octal" "'077'" "EMPTY"
test_case "Binary" "'0b101'" "ERROR"

# ============================================================================
# CATEGORY 12: UNICODE AND ENCODING
# ============================================================================
print_category "CATEGORY 12: UNICODE AND SPECIAL ENCODING"

test_case "Unicode digit" "'①②③'" "ERROR"
test_case "Arabic numerals look-alike" "'١٢٣'" "ERROR"
test_case "Full-width numbers" "'１２３'" "ERROR"
test_case "Superscript" "'¹²³'" "ERROR"
test_case "Subscript" "'₁₂₃'" "ERROR"
test_case "Roman numerals" "'I II III'" "ERROR"
test_case "Emoji numbers" "'1️⃣2️⃣3️⃣'" "ERROR"

# ============================================================================
# CATEGORY 13: MEMORY TORTURE
# ============================================================================
print_category "CATEGORY 13: MEMORY STRESS TESTS"

test_case "1000 sorted numbers" "'$(seq 1 1000 | tr '\n' ' ')'" "EMPTY"
test_case "1000 reverse numbers" "'$(seq 1000 -1 1 | tr '\n' ' ')'" "VALID"
# test_case "Large number repeated pattern" "'$(for i in {1..100}; do echo -n \"$i $((i+1)) \"; done)'" "VALID"

# ============================================================================
# CATEGORY 14: PARSING EDGE CASES
# ============================================================================
print_category "CATEGORY 14: PARSING NIGHTMARES"

test_case "Number then text" "'123abc'" "ERROR"
test_case "Text then number" "'abc123'" "ERROR"
test_case "Space in number" "'12 34' (as single arg)" "ERROR"
test_case "Multiple signs scattered" "'1 -+2 3'" "ERROR"
test_case "Sign without digit" "'1 + 2'" "ERROR"
test_case "Decimal point" "'1.5 2.5'" "ERROR"
test_case "Fraction" "'1/2'" "ERROR"
test_case "Negative zero special" "'-0 +0 0'" "ERROR"

# ============================================================================
# CATEGORY 15: SHELL INJECTION ATTEMPTS
# ============================================================================
print_category "CATEGORY 15: SECURITY - INJECTION ATTEMPTS"

test_case "Command substitution" "'\$(echo 1)'" "ERROR"
test_case "Backtick injection" "'\`echo 1\`'" "ERROR"
test_case "Pipe attempt" "'1 | cat'" "ERROR"
test_case "Semicolon command" "'1; ls'" "ERROR"
test_case "AND operator" "'1 && ls'" "ERROR"
test_case "OR operator" "'1 || ls'" "ERROR"
test_case "Redirect attempt" "'1 > /tmp/test'" "ERROR"
test_case "Background process" "'1 &'" "ERROR"

# ============================================================================
# CATEGORY 16: RACE CONDITION PATTERNS
# ============================================================================
print_category "CATEGORY 16: STRESS PATTERNS"

for i in {1..10}; do
    test_case "Quick succession test $i" "$(shuf -i 1-50 -n 20 | tr '\n' ' ')" "VALID"
done

# ============================================================================
# CATEGORY 17: SPECIFIC ALGORITHM BREAKERS
# ============================================================================
print_category "CATEGORY 17: ALGORITHM STRESS PATTERNS"

test_case "Worst case 3 numbers" "'3 2 1'" "VALID"
test_case "Worst case 5 numbers" "'5 4 3 2 1'" "VALID"
test_case "Near sorted with one swap" "'2 1 3 4 5 6 7 8 9 10'" "VALID"
test_case "Reverse sorted large" "'$(seq 50 -1 1 | tr '\n' ' ')'" "VALID"
test_case "Alternating pattern" "'1 10 2 9 3 8 4 7 5 6'" "VALID"
test_case "Pyramid pattern" "'5 1 9 2 8 3 7 4 6'" "VALID"
test_case "Sawtooth pattern" "'1 5 2 6 3 7 4 8'" "VALID"

# ============================================================================
# CATEGORY 18: EXTREME BOUNDARY COMBINATIONS
# ============================================================================
print_category "CATEGORY 18: BOUNDARY COMBINATIONS"

test_case "Max min only" "'2147483647 -2147483648'" "VALID"
test_case "Max min middle" "'-2147483648 0 2147483647'" "EMPTY"
test_case "Multiple maxs (different)" "'2147483646 2147483647'" "EMPTY"
test_case "Multiple mins (different)" "'-2147483648 -2147483647'" "EMPTY"
test_case "Near boundaries" "'2147483645 2147483646 -2147483647 -2147483648'" "VALID"

# ============================================================================
# FINAL REPORT
# ============================================================================
echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${MAGENTA}                      FINAL RESULTS                             ${CYAN}║${NC}"
echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} Total Tests:   ${BLUE}$TOTAL_TESTS${NC}"
echo -e "${CYAN}║${NC} Passed:        ${GREEN}$PASSED_TESTS${NC}"
echo -e "${CYAN}║${NC} Failed:        ${RED}$FAILED_TESTS${NC}"

if [ $LEAK_TESTS -gt 0 ]; then
    echo -e "${CYAN}║${NC}"
    echo -e "${CYAN}║${NC} ${MAGENTA}MEMORY LEAK ANALYSIS:${NC}"
    echo -e "${CYAN}║${NC} Leak Tests:    ${BLUE}$LEAK_TESTS${NC}"
    echo -e "${CYAN}║${NC} Clean:         ${GREEN}$((LEAK_TESTS - LEAK_FAILS))${NC}"
    echo -e "${CYAN}║${NC} Leaks Found:   ${RED}$LEAK_FAILS${NC}"
fi

echo -e "${CYAN}║${NC}"

if [ $FAILED_TESTS -eq 0 ] && [ $LEAK_FAILS -eq 0 ]; then
    echo -e "${CYAN}║${NC} ${GREEN}🎉 CONGRATULATIONS! ALL TESTS PASSED! 🎉${NC}"
    echo -e "${CYAN}║${NC} ${GREEN}Your push_swap is absolutely BULLETPROOF!${NC}"
    echo -e "${CYAN}║${NC} ${GREEN}NO MEMORY LEAKS! PERFECT! 🔥${NC}"
elif [ $FAILED_TESTS -eq 0 ] && [ $LEAK_FAILS -gt 0 ]; then
    echo -e "${CYAN}║${NC} ${YELLOW}⚠ ALL LOGIC TESTS PASSED!${NC}"
    echo -e "${CYAN}║${NC} ${RED}BUT... YOU HAVE MEMORY LEAKS! 💧${NC}"
    echo -e "${CYAN}║${NC} ${YELLOW}Fix those leaks to get 100%!${NC}"
else
    PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "${CYAN}║${NC} Pass Rate:     ${YELLOW}$PASS_RATE%${NC}"
    echo -e "${CYAN}║${NC}"
    if [ $LEAK_FAILS -gt 0 ]; then
        echo -e "${CYAN}║${NC} ${RED}Issues found: Logic errors AND memory leaks!${NC}"
    else
        echo -e "${CYAN}║${NC} ${YELLOW}Some tests failed. Review the output above.${NC}"
    fi
fi

echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"

if [ $LEAK_FAILS -gt 0 ]; then
    exit $((FAILED_TESTS + LEAK_FAILS))
else
    exit $FAILED_TESTS
fi