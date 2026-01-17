; visible tile area
SCREEN_NUM_COLUMNS		equ 28
SCREEN_NUM_ROWS			equ 35

; total tile area
SCREEN_TILES_PER_COLUMN		equ 37 ; ?
SCREEN_TILES_PER_ROW		equ 32

SCREEN_BYTES_PER_TILE		equ 1
SCREEN_BYTES_PER_ROW		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_ROW)

	; rows 0 - 4 are in hdr tile ram and the rest of the screen is in fg tile ram
	macro	SEEK_XY
	if \2 >= 5
		ldx	#(K007121_TILE_A + $3a0 + ((\2 - 5) * SCREEN_BYTES_PER_TILE) - (\1 * SCREEN_BYTES_PER_ROW))
	else
		ldx	#(K007121_TILE_B + $3a0 + (\2 * SCREEN_BYTES_PER_TILE) - (\1 * SCREEN_BYTES_PER_ROW))
	endif
	endm
