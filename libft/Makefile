# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abdazero <abdazero@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/28 15:48:14 by abdazero          #+#    #+#              #
#    Updated: 2025/11/02 20:38:41 by abdazero         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = libft.a

PART1 = ft_tolower.c ft_toupper.c ft_isprint.c ft_isascii.c ft_isalnum.c \
	ft_isdigit.c ft_isalpha.c ft_atoi.c ft_strlen.c ft_strlcat.c \
	ft_strncmp.c ft_strdup.c ft_calloc.c ft_memcpy.c ft_strchr.c \
	ft_strrchr.c ft_strnstr.c ft_bzero.c ft_memchr.c ft_memcmp.c \
	ft_memset.c ft_memmove.c ft_strlcpy.c

PART2 = ft_itoa.c ft_strjoin.c ft_split.c ft_striteri.c ft_strmapi.c \
	ft_substr.c ft_strtrim.c ft_putchar_fd.c ft_putstr_fd.c \
	ft_putendl_fd.c ft_putnbr_fd.c

SRC = $(PART1) $(PART2)
OBJS = $(SRC:.c=.o)

CC = cc
CFLAGS = -Wall -Wextra -Werror
INCLUDE = -I .
AR = ar rcs
RM = rm -f

.PHONY: clean

all: $(NAME)

$(NAME): $(OBJS)
	$(AR) $(NAME) $(OBJS)

%.o: %.c libft.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean all
