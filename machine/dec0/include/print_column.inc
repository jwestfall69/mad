	; in order to print a string, you have to put each char $40 bytes apart
	macro SEEK_XY
		lea	((TILE1_DATA_START + $7e + (\1 * $40)) - (\2 * 2)), a6
	endm

	macro SEEK_LN
		lea	((TILE1_DATA_START + $7e) - (\1 * 2)), a6
	endm
