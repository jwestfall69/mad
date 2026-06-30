SP_INIT_ADDR		equ WORK_RAM + WORK_RAM_SIZE
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ $2d
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $ff
SOUND_NUM_BIT_ZERO	equ $ff
SOUND_NUM_BIT_ONE	equ $ff

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $3

VD_TILE1_NUM		equ $3c
VD_TILE1_PAL_OFFSET	equ $2

VD_TILE2_NUM		equ $3e
VD_TILE2_PAL_OFFSET	equ $0
