SP_INIT_ADDR		equ WORK_RAM_START + (WORK_RAM_SIZE - 2)
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ $5f		; copyright symbol
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $34
SOUND_NUM_BIT_ZERO	equ $0a		; punch
SOUND_NUM_BIT_ONE	equ $10		; sword

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
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $22
VD_TILE_B0_PAL_OFFSET	equ $4
VD_TILE_B1_NUM		equ $23
VD_TILE_B1_PAL_OFFSET	equ $6
VD_TILE_B2_NUM		equ $24
VD_TILE_B2_PAL_OFFSET	equ $8
VD_TILE_B3_NUM		equ $25
VD_TILE_B3_PAL_OFFSET	equ $a
VD_TILE_BA_NUM		equ $26		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $c
