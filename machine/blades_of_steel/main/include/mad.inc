MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0a
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $44
SOUND_NUM_BIT_ZERO	equ $20 ; ?
SOUND_NUM_BIT_ONE	equ $21	; ?

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
VD_TILE_C0B0_NUM	equ $ff1
VD_TILE_C0B0_PAL_OFFSET	equ $2
VD_TILE_C0B1_NUM	equ $ff2
VD_TILE_C0B1_PAL_OFFSET	equ $4
VD_TILE_C0B2_NUM	equ $ff3
VD_TILE_C0B2_PAL_OFFSET	equ $6
VD_TILE_C0B3_NUM	equ $ff5
VD_TILE_C0B3_PAL_OFFSET	equ $a
VD_TILE_C0B4_NUM	equ $ff7
VD_TILE_C0B4_PAL_OFFSET	equ $e
VD_TILE_C0BA_NUM	equ $ff8	; all bits enabled
VD_TILE_C0BA_PAL_OFFSET	equ $10
; color 1
VD_TILE_C1B0_NUM	equ $ff9
VD_TILE_C1B0_PAL_OFFSET	equ $12
VD_TILE_C1B1_NUM	equ $ffa
VD_TILE_C1B1_PAL_OFFSET	equ $14
VD_TILE_C1B2_NUM	equ $ffb
VD_TILE_C1B2_PAL_OFFSET	equ $16
VD_TILE_C1B3_NUM	equ $ffc
VD_TILE_C1B3_PAL_OFFSET	equ $18
VD_TILE_C1B4_NUM	equ $ffd
VD_TILE_C1B4_PAL_OFFSET	equ $1a
VD_TILE_C1BA_NUM	equ $ffe	; all bits enabled
VD_TILE_C1BA_PAL_OFFSET	equ $1c

	macro SOUND_BIT_DELAY
		lda	#$7f

	.\@:
		WATCHDOG
		ldw	#$1ff
		PSUB	delay
		deca
		bne	.\@
	endm
