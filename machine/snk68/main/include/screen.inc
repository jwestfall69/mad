; visible tile area
SCREEN_NUM_COLUMNS		equ 32
SCREEN_NUM_ROWS			equ 28

; total tile area
SCREEN_TILES_PER_COLUMN		equ 32
SCREEN_TILES_PER_ROW		equ 32

SCREEN_BYTES_PER_TILE		equ 4
SCREEN_BYTES_PER_ROW		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_ROW)

	; goto the correct tile memory location before printing text
	; to the screen
	macro SEEK_XY
		lea	(TILE_BASE + $8 + (\1 * SCREEN_BYTES_PER_ROW) + (\2 * SCREEN_BYTES_PER_TILE)), a6
	endm
