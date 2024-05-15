	; normal style printing
	macro SEEK_XY
		lea	(TILE1_RAM_START + $2040 + (\1 * 2) + (\2 * $40)), a6
	endm

	macro SEEK_LN
		lea	(TILE1_RAM_START + $2040 + (\1 * $40)), a6
	endm
