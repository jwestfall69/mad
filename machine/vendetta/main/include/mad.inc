MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0a ; (c)
CURSOR_CLEAR_CHAR	equ $10

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ TILE2_RAM_START
