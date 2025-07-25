CURSOR_CHAR		equ '*'
CURSOR_CLEAR_CHAR	equ ' '

CHAR_COLON		equ ':'

SOUND_NUM_SUCCESS	equ $18 ; super pang
SOUND_NUM_BIT_ZERO	equ $0d ; dorp
SOUND_NUM_BIT_ONE	equ $01 ; pop

	macro ROMSET_PALETTE_SETUP
		ld	bc, PALETTE_TEXT_COLOR
		ld	(TILE_PALETTE + 2), bc
		ld	(TILE_PALETTE + 4), bc
		ld	(TILE_PALETTE + 6), bc
		ld	(TILE_PALETTE + 8), bc
		ld	(TILE_PALETTE + 10), bc
		ld	(TILE_PALETTE + 12), bc
		ld	(TILE_PALETTE + 14), bc
		ld	(TILE_PALETTE + 16), bc
	endm

	macro ROMSET_HIGHLIGHT_PALETTE_SETUP
		ld	bc, PALETTE_HIGHLIGHT_COLOR
		ld	(TILE_PALETTE + PALETTE_SIZE + 2), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 4), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 6), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 8), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 10), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 12), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 14), bc
		ld	(TILE_PALETTE + PALETTE_SIZE + 16), bc
	endm

; sprite viewer
SV_SPRITE_NUM		equ $53

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
