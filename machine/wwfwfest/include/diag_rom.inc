SP_INIT_ADDR		equ $1c3ff0
DIAG_ROM_SIZE		equ $8000

CURSOR_CHAR		equ ')'
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $93
SOUND_NUM_BIT_ZERO	equ $49		; longer lower fire sound
SOUND_NUM_BIT_ONE	equ $47		; short fire sound

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm
