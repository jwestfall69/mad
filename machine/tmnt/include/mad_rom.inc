SP_INIT_ADDR		equ $063ff0
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ '<'
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $73
SOUND_NUM_BIT_ZERO	equ $87		; punch
SOUND_NUM_BIT_ONE	equ $01		; ting?

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		moveq	#$7f, d1
	.\@:
		WATCHDOG
		move.l	#$fff, d0
		DSUB	delay
		dbra	d1, .\@
	endm
