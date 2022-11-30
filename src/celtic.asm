;--------------------------------------
;
; Celtic CE Source Code - celtic.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022
; License: BSD 3-Clause License
; Last Built: November 29, 2022
;
;--------------------------------------

include 'include/macros.inc'

include 'installer.asm'

	; start of application
	app_start 'CelticCE', '(C)  2022  RoccoLox  Programs'

	include 'main.asm'

	app_data

dummybyte:
	db 0
