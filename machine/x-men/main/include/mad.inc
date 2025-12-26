SP_INIT_ADDR		equ WORK_RAM + WORK_RAM_SIZE
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ $6a
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $e4
SOUND_NUM_BIT_ZERO	equ $67		; punch
SOUND_NUM_BIT_ONE	equ $2b		; laser?

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
VD_TILE_B0_NUM		equ $1
VD_TILE_B0_PAL_OFFSET	equ $2
VD_TILE_B1_NUM		equ $2
VD_TILE_B1_PAL_OFFSET	equ $4
VD_TILE_B2_NUM		equ $3
VD_TILE_B2_PAL_OFFSET	equ $6
VD_TILE_B3_NUM		equ $4
VD_TILE_B3_PAL_OFFSET	equ $8
VD_TILE_B4_NUM		equ $5
VD_TILE_B4_PAL_OFFSET	equ $a
VD_TILE_BA_NUM		equ $6		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $c

; palette number used by all the tile viewers
TVC_PALETTE_NUM		equ $1
TVC_BANK_SLOT_NUM	equ $1
