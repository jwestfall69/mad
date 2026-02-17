MAD_ROM_SIZE		equ $8000
ERROR_ADDRESS_BASE	equ $6000

CURSOR_CLEAR_CHAR	equ $20

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ FIX_TILE_RAM

	; we are only allowed to use a/de registers
	macro SOUND_BIT_DELAY
		DELAY	$ffff
	endm
