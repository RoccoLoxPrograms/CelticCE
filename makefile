#----------------------------------------
#
# Celtic CE Source Code - makefile
# By RoccoLox Programs and TIny_Hacker
# Copyright 2022 - 2023
# License: BSD 3-Clause License
# Last Built: July 24, 2023
#
#----------------------------------------

NAME = CelticCE
SRC = src/celtic.asm

AINST_NAME = AINSTALL
AINST_SRC = src/AINSTALL/ainstall.asm

NAME_BETA = $(NAME)-BETA

FLAG_PREREALEASE = -i 'flag_prerelease := 1'
FLAG_NOT_PRERELEASE = -i 'flag_prerelease := 0'

Q = @

all:
	$(Q)echo Compiling AINSTALL...
	$(Q)fasmg $(AINST_SRC) $(AINST_NAME).8xp
	$(Q)echo Compiling CelticCE...
	$(Q)fasmg $(FLAG_NOT_PRERELEASE) $(SRC) $(NAME).8xp

beta:
	$(Q)echo Compiling AINSTALL...
	$(Q)fasmg $(AINST_SRC) $(AINST_NAME).8xp
	$(Q)echo Compiling CelticCE...
	$(Q)fasmg $(FLAG_PREREALEASE) $(SRC) $(NAME_BETA).8xp

ainstall:
	$(Q)echo Compiling AINSTALL...
	$(Q)fasmg $(AINST_SRC) $(AINST_NAME).8xp

final: all
	$(Q)convbin --archive --8xp-compress zx0 --oformat 8xp-compressed --uppercase --name $(NAME) --iformat 8x --input $(NAME).8xp --output $(NAME).8xp

.PHONY: all beta ainstall final
