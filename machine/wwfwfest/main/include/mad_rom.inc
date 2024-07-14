SP_INIT_ADDR		equ WORK_RAM_START + WORK_RAM_SIZE
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ ')'
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $05
SOUND_NUM_BIT_ZERO	equ $26		; drum?
SOUND_NUM_BIT_ONE	equ $2a		; punch

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $f00003
VD_TILE_B0_PAL_OFFSET	equ $1e
VD_TILE_B1_NUM		equ $630004
VD_TILE_B1_PAL_OFFSET	equ $e
VD_TILE_B2_NUM		equ $8b0007
VD_TILE_B2_PAL_OFFSET	equ $2
VD_TILE_B3_NUM		equ $3d0009
VD_TILE_B3_PAL_OFFSET	equ $6
VD_TILE_BA_NUM		equ $08000b	; all bits enabled
VD_TILE_BA_PAL_OFFSET1	equ $4
VD_TILE_BA_PAL_OFFSET2	equ $10
