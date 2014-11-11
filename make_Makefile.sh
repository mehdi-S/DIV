#!/bin/bash

if test -f "Makefile"; then rm Makefile;fi
ls ft_*.c > list
vim Makefile -c :Stdheader -c :wq
echo "
\\n\\nDEL = rm -f

OBJ = \$(SRC:.c=.o)

FLAG = -Wall -Werror -Wextra

all: \$(NAME)

\$(NAME):
\\t@gcc -c \$(FLAG) \$(SRC)
\\t@ar rc \$(NAME) \$(OBJ)
\\t@ranlib \$(NAME)
\\t@echo
\\t@echo \"make -> \$(NAME) created\"
\\t@echo

clean:
\\t@\$(DEL) \$(OBJ)
\\t@echo
\\t@echo \"clean -> .o deleted\"
\\t@echo

fclean: clean
\\t@\$(DEL) \$(NAME)
\\t@echo
\\t@echo \"fclean -> ... and \$(NAME) deleted\"
\\t@echo

re: fclean all
\\t@echo
\\t@echo \"re -> \$(NAME) reloaded\"
\\t@echo

.PHONY: all clean fclean re
" > temp
echo "
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   make_Makefile.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: acivita <acivita@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2014/11/11 01:27:35 by acivita           #+#    #+#             */
/*   Updated: 2014/11/11 04:24:03 by acivita          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

# include <fcntl.h>
# include <unistd.h>
# include <sys/types.h>
# include <sys/uio.h>

# define BUFF_SIZE 10000

void		ft_putchar(char c)
{
	write(1, &c, 1);
}

void		ft_putstr(char *str)
{
	while(*str)
		ft_putchar(*str++);
}

void		ft_putchar_fd(char c, int fd)
{
	write(fd, &c, 1);
}

void		ft_putstr_fd(char *s, int fd)
{
	while (*s)
		ft_putchar_fd(*s++, fd);

}
int			main(void)
{
int		fd;
int 	ret;
char	buf[BUFF_SIZE];
char	*dest;
int		i;
int		ct;

if ((fd = open(\"list\", O_RDONLY)) == -1)
ft_putstr(\"open() error fd\");
i = 0;
ct = 0;
while ((ret = read(fd, buf, BUFF_SIZE)))
buf[ret] = '\\\0';
if ((close(fd)) == -1)
ft_putstr(\"close() error fd\");
if ((fd = open(\"Makefile\", O_RDWR | O_APPEND)) == -1)
ft_putstr(\"open() error fd\");
ft_putstr_fd(\"NAME = libft.a\\\n\", fd);
i = 0;
while (buf[i] != '\\\0')
{
if (i == 0)
ft_putstr_fd(\"\\\nSRC = \", fd);
if (buf[i] == '\\\n')
{
ct++;
if (ct % 4 == 0)
{
ft_putchar_fd('\\\n', fd);
ft_putstr_fd(\"SRC += \", fd);
}
else
ft_putstr_fd(\" \", fd);
}
else
ft_putchar_fd(buf[i], fd);
i++;
}
if ((close(fd)) == -1)
ft_putstr(\"close() error \");

if ((fd = open(\"temp\", O_RDWR | O_APPEND)) == -1)
	ft_putstr(\"open() error fd\");
ret = read(fd, buf, BUFF_SIZE);
	buf[ret] = '\\\0';
if ((close(fd)) == -1)
	ft_putstr(\"close() error \");
if ((fd = open(\"Makefile\", O_RDWR | O_APPEND)) == -1)
	ft_putstr(\"open() error fd\");
ft_putstr_fd(buf, fd);
	if ((close(fd)) == -1)
		ft_putstr(\"close() error \");

return (0);
}" > main.c
gcc main.c
./a.out 
rm main.c temp list a.out
make
make fclean
