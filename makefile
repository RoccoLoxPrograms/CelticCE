#--------------------------------------
#
# Celtic CE Source Code - makefile
# By RoccoLox Programs and TIny_Hacker
# Copyright 2022 - 2023
# License: BSD 3-Clause License
# Last Built: January 17, 2023
#
#--------------------------------------

NAME = CelticCE
SRC = src/celtic.asm

NAME_BETA = $(NAME)-BETA

FLAG_PREREALEASE = -i 'flag_prerelease := 1'
FLAG_NOT_PRERELEASE = -i 'flag_prerelease := 0'

all:
	fasmg $(FLAG_NOT_PRERELEASE) $(SRC) $(NAME).8xp

beta:
	fasmg $(FLAG_PREREALEASE) $(SRC) $(NAME_BETA).8xp

final: all
	convbin --archive --8xp-compress zx0 --oformat 8xp-compressed --uppercase --name $(NAME) --iformat 8x --input $(NAME).8xp --output $(NAME).8xp
