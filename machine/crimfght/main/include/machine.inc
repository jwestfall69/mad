WORK_RAM_START			equ $0000
WORK_RAM_SIZE			equ $2000
WORK_RAM_ADDRESS_LINES		equ 13

; bank switched into work ram space
PALETTE_RAM_START		equ $0000
PALETTE_RAM_SIZE		equ $400
PALETTE_RAM_ADDRESS_LINES	equ 10

TILE1_RAM_START			equ $2000
TILE1_RAM_SIZE			equ $1800
TILE1_RAM_ADDRESS_LINES		equ 11

TILE2_RAM_START			equ $4000
TILE2_RAM_SIZE			equ $1800
TILE2_RAM_ADDRESS_LINES		equ 11

ROM_SIZE			equ $8000
ROM_START			equ $8000

REG_INPUT_P1			equ $3f81
REG_WATCHDOG			equ $3f88
REG_SOUND			equ $3f8c

CHAR_COLON			equ $10		; no colon char, using space

; note only 40 tiles are visable
SCREEN_TILES_PER_LINE		equ 64
SCREEN_BYTES_PER_TILE		equ 1
SCREEN_BYTES_PER_LINE		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_LINE)

	macro	SEEK_XY
		ldx	#(TILE2_RAM_START + $8c + \1 + (\2 * SCREEN_BYTES_PER_LINE))
	endm

	macro	SEEK_LN
		ldy	#(\1 * SCREEN_BYTES_PER_LINE)
		ldy	#(TILE2_RAM_START + $8c)
		ldx	#(TILE2_RAM_START + $8c + (\1 * SCREEN_BYTES_PER_LINE))
	endm

	macro	WATCHDOG
		; will probably cause problems..
		lda	REG_WATCHDOG
	endm
