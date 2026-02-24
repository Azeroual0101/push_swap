NAME = push_swap

CC = cc
CFLAGS = -Wall -Wextra -Werror
RM = rm -f

PARSING_DIR = parsing/
OPERATIONS_DIR = operations/
SORTS_DIR = sorts/

PARSING_SRCS = \
	$(PARSING_DIR)ft_atoi.c \
	$(PARSING_DIR)ft_split.c \
	$(PARSING_DIR)parse_args.c \
	$(PARSING_DIR)utils_1.c \
	$(PARSING_DIR)utils_2.c

OPERATIONS_SRCS = \
	$(OPERATIONS_DIR)base_rotate.c \
	$(OPERATIONS_DIR)reverse_rotate.c \
	$(OPERATIONS_DIR)rotate.c \
	$(OPERATIONS_DIR)push.c \
	$(OPERATIONS_DIR)swap.c

SORTS_SRCS = \
	$(SORTS_DIR)sort_two.c \
	$(SORTS_DIR)sort_three.c \
	$(SORTS_DIR)sort_four.c \
	$(SORTS_DIR)sort_five.c \
	$(SORTS_DIR)utils_sort.c \
	$(SORTS_DIR)radix_sort.c

MAIN_SRC = main.c

SRCS = $(PARSING_SRCS) $(OPERATIONS_SRCS) $(SORTS_SRCS) $(MAIN_SRC)

OBJS = $(SRCS:.c=.o)
HEADER = push_swap.h

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

%.o: %.c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re