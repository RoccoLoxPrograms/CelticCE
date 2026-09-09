;----------------------------------------
;
; Celtic CE Source Code - xLIBCE/largefont.asm
; By RoccoLox Programs and TIny_Hacker
; Copyright 2022 - 2026
; License: BSD 3-Clause License
; Last Built: September 9, 2026
;
;----------------------------------------

largeFontData:
.glyph_20: ;  
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_21: ; !
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00011000b
    db 00000000b
.glyph_22: ; "
    db 01100110b
    db 01100110b
    db 01100110b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_23: ; #
    db 01100110b
    db 01100110b
    db 11111111b
    db 01100110b
    db 11111111b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_24: ; $
    db 00011000b
    db 00111110b
    db 01100000b
    db 00111100b
    db 00000110b
    db 01111100b
    db 00011000b
    db 00000000b
.glyph_25: ; %
    db 01100010b
    db 01100110b
    db 00001100b
    db 00011000b
    db 00110000b
    db 01100110b
    db 01000110b
    db 00000000b
.glyph_26: ; &
    db 00111000b
    db 01101100b
    db 01101100b
    db 00111000b
    db 01101111b
    db 01100110b
    db 00111111b
    db 00000000b
.glyph_27: ; '
    db 00011000b
    db 00011000b
    db 00110000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_28: ; (
    db 00001100b
    db 00011000b
    db 00110000b
    db 00110000b
    db 00110000b
    db 00011000b
    db 00001100b
    db 00000000b
.glyph_29: ; )
    db 00110000b
    db 00011000b
    db 00001100b
    db 00001100b
    db 00001100b
    db 00011000b
    db 00110000b
    db 00000000b
.glyph_2A: ; *
    db 00000000b
    db 01100110b
    db 00111100b
    db 11111111b
    db 00111100b
    db 01100110b
    db 00000000b
    db 00000000b
.glyph_2B: ; +
    db 00000000b
    db 00011000b
    db 00011000b
    db 01111110b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00000000b
.glyph_2C: ; ,
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00110000b
.glyph_2D: ; -
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111110b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_2E: ; .
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_2F: ; /
    db 00000000b
    db 00000011b
    db 00000110b
    db 00001100b
    db 00011000b
    db 00110000b
    db 01100000b
    db 00000000b
.glyph_30: ; 0
    db 00111100b
    db 01100110b
    db 01101110b
    db 01111110b
    db 01110110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_31: ; 1
    db 00011000b
    db 00111000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00111100b
    db 00000000b
.glyph_32: ; 2
    db 00111100b
    db 01100110b
    db 00000110b
    db 00001100b
    db 00110000b
    db 01100000b
    db 01111110b
    db 00000000b
.glyph_33: ; 3
    db 00111100b
    db 01100110b
    db 00000110b
    db 00011100b
    db 00000110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_34: ; 4
    db 00001110b
    db 00011110b
    db 00110110b
    db 01100110b
    db 01111111b
    db 00000110b
    db 00001111b
    db 00000000b
.glyph_35: ; 5
    db 01111110b
    db 01100000b
    db 01111100b
    db 00000110b
    db 00000110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_36: ; 6
    db 00111100b
    db 01100110b
    db 01100000b
    db 01111100b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_37: ; 7
    db 01111110b
    db 01100110b
    db 00001100b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_38: ; 8
    db 00111100b
    db 01100110b
    db 01100110b
    db 00111100b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_39: ; 9
    db 00111100b
    db 01100110b
    db 01100110b
    db 00111110b
    db 00000110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_3A: ; :
    db 00000000b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_3B: ; ;
    db 00000000b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00110000b
.glyph_3C: ; <
    db 00001100b
    db 00011000b
    db 00110000b
    db 01100000b
    db 00110000b
    db 00011000b
    db 00001100b
    db 00000000b
.glyph_3D: ; =
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111110b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_3E: ; >
    db 00110000b
    db 00011000b
    db 00001100b
    db 00000110b
    db 00001100b
    db 00011000b
    db 00110000b
    db 00000000b
.glyph_3F: ; ?
    db 00111100b
    db 01100110b
    db 00000110b
    db 00001100b
    db 00011000b
    db 00000000b
    db 00011000b
    db 00000000b
.glyph_40: ; @
    db 00111100b
    db 01100110b
    db 01101110b
    db 01101110b
    db 01100000b
    db 01100010b
    db 00111100b
    db 00000000b
.glyph_41: ; A
    db 00111100b
    db 01100110b
    db 01100110b
    db 01111110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_42: ; B
    db 01111100b
    db 01100110b
    db 01100110b
    db 01111100b
    db 01100110b
    db 01100110b
    db 01111100b
    db 00000000b
.glyph_43: ; C
    db 00111100b
    db 01100110b
    db 01100000b
    db 01100000b
    db 01100000b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_44: ; D
    db 01111000b
    db 01101100b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01101100b
    db 01111000b
    db 00000000b
.glyph_45: ; E
    db 01111110b
    db 01100000b
    db 01100000b
    db 01111000b
    db 01100000b
    db 01100000b
    db 01111110b
    db 00000000b
.glyph_46: ; F
    db 01111110b
    db 01100000b
    db 01100000b
    db 01111000b
    db 01100000b
    db 01100000b
    db 01100000b
    db 00000000b
.glyph_47: ; G
    db 00111100b
    db 01100110b
    db 01100000b
    db 01101110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_48: ; H
    db 01100110b
    db 01100110b
    db 01100110b
    db 01111110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_49: ; I
    db 00111100b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00111100b
    db 00000000b
.glyph_4A: ; J
    db 00011110b
    db 00001100b
    db 00001100b
    db 00001100b
    db 00001100b
    db 01101100b
    db 00111000b
    db 00000000b
.glyph_4B: ; K
    db 01100110b
    db 01101100b
    db 01111000b
    db 01110000b
    db 01111000b
    db 01101100b
    db 01100110b
    db 00000000b
.glyph_4C: ; L
    db 01100000b
    db 01100000b
    db 01100000b
    db 01100000b
    db 01100000b
    db 01100000b
    db 01111110b
    db 00000000b
.glyph_4D: ; M
    db 01100011b
    db 01110111b
    db 01111111b
    db 01101011b
    db 01100011b
    db 01100011b
    db 01100011b
    db 00000000b
.glyph_4E: ; N
    db 01100110b
    db 01110110b
    db 01111110b
    db 01111110b
    db 01101110b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_4F: ; O
    db 00111100b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_50: ; P
    db 01111100b
    db 01100110b
    db 01100110b
    db 01111100b
    db 01100000b
    db 01100000b
    db 01100000b
    db 00000000b
.glyph_51: ; Q
    db 00111100b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00001110b
    db 00000000b
.glyph_52: ; R
    db 01111100b
    db 01100110b
    db 01100110b
    db 01111100b
    db 01111000b
    db 01101100b
    db 01100110b
    db 00000000b
.glyph_53: ; S
    db 00111100b
    db 01100110b
    db 01100000b
    db 00111100b
    db 00000110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_54: ; T
    db 01111110b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_55: ; U
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_56: ; V
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00011000b
    db 00000000b
.glyph_57: ; W
    db 01100011b
    db 01100011b
    db 01100011b
    db 01101011b
    db 01111111b
    db 01110111b
    db 01100011b
    db 00000000b
.glyph_58: ; X
    db 01100110b
    db 01100110b
    db 00111100b
    db 00011000b
    db 00111100b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_59: ; Y
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_5A: ; Z
    db 01111110b
    db 00000110b
    db 00001100b
    db 00011000b
    db 00110000b
    db 01100000b
    db 01111110b
    db 00000000b
.glyph_5B: ; [
    db 00111100b
    db 00110000b
    db 00110000b
    db 00110000b
    db 00110000b
    db 00110000b
    db 00111100b
    db 00000000b
.glyph_5C: ; \
    db 00000000b
    db 01100000b
    db 00110000b
    db 00011000b
    db 00001100b
    db 00000110b
    db 00000011b
    db 00000000b
.glyph_5D: ; ]
    db 00111100b
    db 00001100b
    db 00001100b
    db 00001100b
    db 00001100b
    db 00001100b
    db 00111100b
    db 00000000b
.glyph_5E: ; ^
    db 00001100b
    db 00011110b
    db 00110011b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_5F: ; _
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 01111111b
    db 00000000b
.glyph_60: ; `
    db 00011000b
    db 00011000b
    db 00001100b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b
.glyph_61: ; a
    db 00000000b
    db 00000000b
    db 00111100b
    db 00000110b
    db 00111110b
    db 01100110b
    db 00111110b
    db 00000000b
.glyph_62: ; b
    db 00000000b
    db 01100000b
    db 01100000b
    db 01111100b
    db 01100110b
    db 01100110b
    db 01111100b
    db 00000000b
.glyph_63: ; c
    db 00000000b
    db 00000000b
    db 00111100b
    db 01100110b
    db 01100000b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_64: ; d
    db 00000000b
    db 00000110b
    db 00000110b
    db 00111110b
    db 01100110b
    db 01100110b
    db 00111110b
    db 00000000b
.glyph_65: ; e
    db 00000000b
    db 00000000b
    db 00111100b
    db 01100110b
    db 01111110b
    db 01100000b
    db 00111100b
    db 00000000b
.glyph_66: ; f
    db 00000000b
    db 00001110b
    db 00011000b
    db 00111110b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_67: ; g
    db 00000000b
    db 00000000b
    db 00111110b
    db 01100110b
    db 01100110b
    db 00111110b
    db 00000110b
    db 01111100b
.glyph_68: ; h
    db 00000000b
    db 01100000b
    db 01100000b
    db 01111100b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_69: ; i
    db 00000000b
    db 00011000b
    db 00000000b
    db 00111000b
    db 00011000b
    db 00011000b
    db 00111100b
    db 00000000b
.glyph_6A: ; j
    db 00000000b
    db 00011000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 01110000b
.glyph_6B: ; k
    db 00000000b
    db 01100000b
    db 01100000b
    db 01101100b
    db 01111000b
    db 01101100b
    db 01100110b
    db 00000000b
.glyph_6C: ; l
    db 00000000b
    db 00111000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00111100b
    db 00000000b
.glyph_6D: ; m
    db 00000000b
    db 00000000b
    db 00110110b
    db 01111111b
    db 01101011b
    db 01101011b
    db 01100011b
    db 00000000b
.glyph_6E: ; n
    db 00000000b
    db 00000000b
    db 01111100b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00000000b
.glyph_6F: ; o
    db 00000000b
    db 00000000b
    db 00111100b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00000000b
.glyph_70: ; p
    db 00000000b
    db 00000000b
    db 01111100b
    db 01100110b
    db 01100110b
    db 01111100b
    db 01100000b
    db 01100000b
.glyph_71: ; q
    db 00000000b
    db 00000000b
    db 00111110b
    db 01100110b
    db 01100110b
    db 00111110b
    db 00000110b
    db 00000110b
.glyph_72: ; r
    db 00000000b
    db 00000000b
    db 01111100b
    db 01100110b
    db 01100000b
    db 01100000b
    db 01100000b
    db 00000000b
.glyph_73: ; s
    db 00000000b
    db 00000000b
    db 00111110b
    db 01100000b
    db 00111100b
    db 00000110b
    db 01111100b
    db 00000000b
.glyph_74: ; t
    db 00011000b
    db 00011000b
    db 00111110b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00001110b
    db 00000000b
.glyph_75: ; u
    db 00000000b
    db 00000000b
    db 01100110b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111110b
    db 00000000b
.glyph_76: ; v
    db 00000000b
    db 00000000b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111100b
    db 00011000b
    db 00000000b
.glyph_77: ; w
    db 00000000b
    db 00000000b
    db 01100011b
    db 01101011b
    db 01101011b
    db 01111111b
    db 00110110b
    db 00000000b
.glyph_78: ; x
    db 00000000b
    db 00000000b
    db 01100110b
    db 00111100b
    db 00011000b
    db 00111100b
    db 01100110b
    db 00000000b
.glyph_79: ; y
    db 00000000b
    db 00000000b
    db 01100110b
    db 01100110b
    db 01100110b
    db 00111110b
    db 00001100b
    db 01111000b
.glyph_7A: ; z
    db 00000000b
    db 00000000b
    db 01111110b
    db 00001100b
    db 00011000b
    db 00110000b
    db 01111110b
    db 00000000b
.glyph_7B: ; {
    db 00011100b
    db 00110000b
    db 00110000b
    db 01100000b
    db 00110000b
    db 00110000b
    db 00011100b
    db 00000000b
.glyph_7C: ; |
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00011000b
    db 00000000b
.glyph_7D: ; }
    db 00111000b
    db 00001100b
    db 00001100b
    db 00000110b
    db 00001100b
    db 00001100b
    db 00111000b
    db 00000000b
.glyph_7E: ; ~
    db 00000000b
    db 00000000b
    db 00000000b
    db 00111011b
    db 01101110b
    db 00000000b
    db 00000000b
    db 00000000b
