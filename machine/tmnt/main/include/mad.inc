SP_INIT_ADDR		equ WORK_RAM + WORK_RAM_SIZE
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


; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $6		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $31
VD_TILE_B0_PAL_OFFSET	equ $4
VD_TILE_B1_NUM		equ $32
VD_TILE_B1_PAL_OFFSET	equ $8
VD_TILE_B2_NUM		equ $33
VD_TILE_B2_PAL_OFFSET	equ $c
VD_TILE_B3_NUM		equ $34
VD_TILE_B3_PAL_OFFSET	equ $10
VD_TILE_B4_NUM		equ $35
VD_TILE_B4_PAL_OFFSET	equ $14
VD_TILE_BA_NUM		equ $36		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $18
