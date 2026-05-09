; visible tile area
SCREEN_NUM_COLUMNS		equ 32
SCREEN_NUM_ROWS			equ 28

; total tile area
SCREEN_TILES_PER_COLUMN		equ 28 ; ?
SCREEN_TILES_PER_ROW		equ 32

SCREEN_BYTES_PER_TILE		equ 1
SCREEN_BYTES_PER_ROW		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_ROW)

	; mimicking contra even though the game doesn't actuall do this
	macro	SEEK_XY
	if \2 >= 5
		ldx	#(K007121_G15_TILE_A + $40 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_ROW))
	else
		ldx	#(K007121_G15_TILE_B + $40 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_ROW))
	endif
	endm
