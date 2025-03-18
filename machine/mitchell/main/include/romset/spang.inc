CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

CHAR_COLON			equ ':'

	macro ROMSET_PALETTE_SETUP
		ld	bc, PALETTE_TEXT_COLOR
		ld	(PALETTE_RAM_START + 2), bc
		ld	(PALETTE_RAM_START + 4), bc
		ld	(PALETTE_RAM_START + 6), bc
		ld	(PALETTE_RAM_START + 8), bc
		ld	(PALETTE_RAM_START + 10), bc
		ld	(PALETTE_RAM_START + 12), bc
		ld	(PALETTE_RAM_START + 14), bc
		ld	(PALETTE_RAM_START + 16), bc
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $11
VD_TILE_B0_PAL_OFFSET	equ $2
VD_TILE_B1_NUM		equ $12
VD_TILE_B1_PAL_OFFSET	equ $4
VD_TILE_B2_NUM		equ $13
VD_TILE_B2_PAL_OFFSET	equ $6
VD_TILE_B3_NUM		equ $14
VD_TILE_B3_PAL_OFFSET	equ $8
VD_TILE_BA_NUM		equ $15		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $a
