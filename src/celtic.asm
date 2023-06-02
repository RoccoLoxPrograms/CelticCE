;----------------------------------------
;
; Celtic CE Source Code - celtic.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2023
; License: BSD 3-Clause License
; Last Built: June 1, 2023
;
;----------------------------------------

include 'include/macros.inc'

include 'installer.asm'

	app_start 'CelticCE', '(C)  2022-2023  RoccoLox  Programs'

	include 'main.asm'
	include 'hooks.asm'
	include 'celtic2cse.asm'
	include 'dce.asm'
	include 'graphics.asm'
	include 'osutils.asm'
	include 'celtic3.asm'
	include 'convop1.asm'
	include 'utils.asm'
	include 'error.asm'
	include 'rodata.asm'

	app_data

dummybyte:
	db 0
