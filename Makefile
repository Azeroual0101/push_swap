NAME = push_swap.a

CC = cc
CFLAGS = -Wall -Wextra -Werror
AR = ar rcs
RM = rm -f


PARSING_DIR = parsing/
OPERATIONS_DIR = operations/
SORTS_DIR = sorts/

SRCS = \
$(PARSING_DIR)ft_atoi.c \
$(PARSING_DIR)ft_split.c \
$(PARSING_DIR)parse_args.c \
$(PARSING_DIR)utils.c \
$(OPERATIONS_DIR)base_rotate.c \
$(OPERATIONS_DIR)reverse_rotate.c \
$(OPERATIONS_DIR)rotate.c \
$(OPERATIONS_DIR)push.c \
$(OPERATIONS_DIR)swap.c \
$(SORTS_DIR)sort_three.c \
$(SORTS_DIR)sort_five.c \
$(SORTS_DIR)utils_sort.c \
$(SORTS_DIR)radix_sort.c



OBJS = $(SRCS:.c=.o)
HEADER = push_swap.h

all: $(NAME)

$(NAME): $(OBJS)
	$(AR) $(NAME) $(OBJS)

%.o: %.c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJS)
	clear

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re