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
