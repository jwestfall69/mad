MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ '-'
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $53
SOUND_NUM_BIT_ZERO	equ $09
SOUND_NUM_BIT_ONE	equ $0a


	macro SOUND_BIT_DELAY
		lda	#$7f

	.\@:
		WATCHDOG
		ldw	#$1ff
		PSUB	delay
		deca
		bne	.\@
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $6		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $14fc
VD_TILE_B0_PAL_OFFSET	equ $4
VD_TILE_B1_NUM		equ $00a0
VD_TILE_B1_PAL_OFFSET	equ $a
VD_TILE_B2_NUM		equ $18b0
VD_TILE_B2_PAL_OFFSET	equ $e
VD_TILE_B3_NUM		equ $1877
VD_TILE_B3_PAL_OFFSET	equ $10
VD_TILE_B4_NUM		equ $1c34
VD_TILE_B4_PAL_OFFSET	equ $14
VD_TILE_BA_NUM		equ $111e	; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $1e
