*This project has been created as part of the 42 curriculum by abdazero.*

# push_swap

## Description

**push_swap** is a sorting algorithm project from the 42 school curriculum. The goal is to sort a stack of integers using two stacks (`a` and `b`) and a limited set of operations, while minimizing the total number of operations used.

The program receives a list of integers as arguments, then outputs the shortest sequence of instructions needed to sort them in ascending order in stack `a`.

### Available operations

| Operation | Description |
|-----------|-------------|
| `sa` | Swap the first 2 elements of stack a |
| `sb` | Swap the first 2 elements of stack b |
| `ss` | `sa` and `sb` simultaneously |
| `pa` | Push top of stack b to stack a |
| `pb` | Push top of stack a to stack b |
| `ra` | Rotate stack a upward (first becomes last) |
| `rb` | Rotate stack b upward (first becomes last) |
| `rr` | `ra` and `rb` simultaneously |
| `rra` | Reverse rotate stack a (last becomes first) |
| `rrb` | Reverse rotate stack b (last becomes first) |
| `rrr` | `rra` and `rrb` simultaneously |

### Algorithm

The project uses different strategies depending on the size of the input:

- **1–2 elements** : trivial cases, 0 or 1 operation
- **3 elements** : hardcoded optimal sort covering all 6 permutations (max 2 ops)
- **4–5 elements** : push 1–2 elements to `b`, sort the 3 remaining with `sort_three`, then reinsert
- **6+ elements** : **Radix Sort (LSD)** — elements are first indexed (0 = smallest, n-1 = largest), then sorted bit by bit from least significant to most significant

The Radix sort runs in **O(n × log n)** operations.

## Instructions

### Project structure

```
push_swap/
├── Makefile
├── README.md
├── main.c
├── push_swap.h
├── parsing/
│   ├── ft_atoi.c
│   ├── ft_split.c
│   ├── parse_args.c
│   ├── utils_1.c
│   └── utils_2.c
├── operations/
│   ├── base_rotate.c
│   ├── reverse_rotate.c
│   ├── rotate.c
│   ├── push.c
│   └── swap.c
└── sorts/
    ├── sort_two.c
    ├── sort_three.c
    ├── sort_four.c
    ├── sort_five.c
    ├── utils_sort.c
    └── radix_sort.c
```

### Compilation

```bash
make        # compiles push_swap
make clean  # removes object files
make fclean # removes object files + executable
make re     # fclean + make
```

The Makefile compiles all `.c` files from `parsing/`, `operations/`, and `sorts/` directories with flags `-Wall -Wextra -Werror`.

### Execution

```bash
./push_swap 3 1 4 5 9 2 6
```

The first argument is the top of the stack. The program prints one instruction per line to stdout.

### Testing with checker

```bash
ARG="4 67 3 87 23"
./push_swap $ARG | ./checker_OS $ARG
```

The checker outputs `OK` if the instructions correctly sort the stack, `KO` otherwise.

### Counting operations

```bash
./push_swap 4 67 3 87 23 | wc -l
```

### Error handling

The program prints `Error` to stderr and exits if:
- An argument is not a valid integer
- An argument exceeds INT_MAX or is below INT_MIN
- There are duplicate values

## Usage Examples

```bash
# Already sorted — no output
./push_swap 1 2 3 4 5

# Two elements
./push_swap 2 1
# Output: sa

# Five elements
./push_swap 5 3 1 4 2

# Negative numbers
./push_swap -5 -1 -3 0 2

# Using a variable for stress testing
ARG=$(shuf -i 1-100 -n 100 | tr '\n' ' ')
./push_swap $ARG | wc -l
```

## Resources

### References

- [Radix Sort — Wikipedia](https://en.wikipedia.org/wiki/Radix_sort)
- [Sorting Algorithms Visualizer](https://visualgo.net/en/sorting)
- [Big O Notation — Wikipedia](https://en.wikipedia.org/wiki/Big_O_notation)
- [Push_swap — Medium article by Ayaz Mammadov](https://medium.com/@ayogun/push-swap-c1f5d2d41e97)
- [42 push_swap visualizer](https://github.com/o-reo/push_swap_visualizer)

### AI usage

AI assistance contributed to improving the clarity and quality of the documentation, ensuring grammatical accuracy, and supplying explanatory insights.