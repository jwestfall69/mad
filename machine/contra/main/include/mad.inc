MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0a
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $4d
SOUND_NUM_BIT_ZERO	equ $07 ; ?
SOUND_NUM_BIT_ONE	equ $13	; insert coin?

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ PALETTE_RAM

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $6		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
; there are only 2 palettes available so below represents 2 colors
; color 0
VD_TILE_C0B0_NUM	equ $1
VD_TILE_C0B0_PAL_OFFSET	equ $2
VD_TILE_C0B1_NUM	equ $2
VD_TILE_C0B1_PAL_OFFSET	equ $4
VD_TILE_C0B2_NUM	equ $4
VD_TILE_C0B2_PAL_OFFSET	equ $8
VD_TILE_C0B3_NUM	equ $5
VD_TILE_C0B3_PAL_OFFSET	equ $a
VD_TILE_C0B4_NUM	equ $6
VD_TILE_C0B4_PAL_OFFSET	equ $c
VD_TILE_C0BA_NUM	equ $7		; all bits enabled
VD_TILE_C0BA_PAL_OFFSET	equ $e
; color 1
VD_TILE_C1B0_NUM	equ $8
VD_TILE_C1B0_PAL_OFFSET	equ $10
VD_TILE_C1B1_NUM	equ $9
VD_TILE_C1B1_PAL_OFFSET	equ $12
VD_TILE_C1B2_NUM	equ $a
VD_TILE_C1B2_PAL_OFFSET	equ $14
VD_TILE_C1B3_NUM	equ $b
VD_TILE_C1B3_PAL_OFFSET	equ $16
VD_TILE_C1B4_NUM	equ $c
VD_TILE_C1B4_PAL_OFFSET	equ $18
VD_TILE_C1BA_NUM	equ $d		; all bits enabled
VD_TILE_C1BA_PAL_OFFSET	equ $1a

	macro SOUND_BIT_DELAY
		lda	#$7f

	.\@:
		WATCHDOG
		ldw	#$1ff
		PSUB	delay
		deca
		bne	.\@
	endm
