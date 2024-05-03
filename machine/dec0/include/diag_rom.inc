SP_INIT_ADDR		equ $ffbffc
DIAG_ROM_SIZE		equ $8000

CURSOR_CHAR		equ '*'
CURSOR_CLEAR_CHAR	equ $0

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm
