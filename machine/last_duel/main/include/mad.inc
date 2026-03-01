SP_INIT_ADDR		equ WORK_RAM + WORK_RAM_SIZE
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ $2a
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $28
SOUND_NUM_BIT_ZERO	equ $06
SOUND_NUM_BIT_ONE	equ $01

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm
