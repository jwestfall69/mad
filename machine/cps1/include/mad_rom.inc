SP_INIT_ADDR			equ $fffffc
MAD_ROM_SIZE			equ $8000

PALETTE_TEXT_COLOR		equ $ffff
PALETTE_TEXT_SHADOW_COLOR	equ $2222
PALETTE_BACKGROUND_COLOR	equ $0

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm