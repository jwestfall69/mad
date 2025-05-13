MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $3e
CURSOR_CLEAR_CHAR	equ $0

SOUND_NUM_SUCCESS	equ $37
SOUND_NUM_BIT_ZERO	equ $10
SOUND_NUM_BIT_ONE	equ $11

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ VIDEO_RAM

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
VD_TILE_B0_NUM		equ $0101
VD_TILE_B0_PAL_OFFSET	equ $6
VD_TILE_B1_NUM		equ $11fe
VD_TILE_B1_PAL_OFFSET	equ $c
VD_TILE_B2_NUM		equ $1d63
VD_TILE_B2_PAL_OFFSET	equ $e
VD_TILE_B3_NUM		equ $010d
VD_TILE_B3_PAL_OFFSET	equ $10
VD_TILE_B4_NUM		equ $0465
VD_TILE_B4_PAL_OFFSET	equ $18
VD_TILE_BA_NUM		equ $11ff	; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $1a
