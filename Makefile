NAME	= push_swap.a

CC		= cc
CFLAGS	= -Wall -Wextra -Werror
AR		= ar rcs
RM		= rm -f


SRCS	= parse_args.c \
		  utils.c \
		  ft_atoi.c \
		  ft_split.c

OBJS	= $(SRCS:.c=.o)


HEADER	= push_swap.h

all: $(NAME)


$(NAME): $(OBJS)
	$(AR) $(NAME) $(OBJS)


%.o: %.c $(HEADER)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re