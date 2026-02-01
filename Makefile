NAME = push_swap

CC = cc
CFLAGS = -Wall -Wextra -Werror

SRCS = srcs/main.c \
       srcs/parsing/parse_args.c \
       srcs/parsing/validate_args.c \
       srcs/utils/utils.c

OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) -o $(NAME) $(OBJS)

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all