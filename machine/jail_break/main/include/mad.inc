MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0a	; (c)
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $12
SOUND_NUM_BIT_ZERO	equ $15
SOUND_NUM_BIT_ONE	equ $1b

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ $2000

	; we are only allowed to use d register
	macro SOUND_BIT_DELAY
		DELAY	#$3fff
	endm
