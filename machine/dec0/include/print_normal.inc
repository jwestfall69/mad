	; normal style printing
	macro SEEK_XY
		lea	(TILE1_RAM_START + $2040 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_LINE)), a6
	endm

	macro SEEK_LN
		lea	(TILE1_RAM_START + $2040 + (\1 * SCREEN_BYTES_PER_LINE)), a6
	endm
