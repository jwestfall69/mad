	include "romset.inc"

ROM_START			equ $0
ROM_SIZE			equ $20000

PALETTE_RAM_START		equ $310000
PALETTE_RAM_SIZE		equ $800
PALETTE_RAM_ADDRESS_LINES	equ 11
PALETTE_RAM_MASK		equ $ffff
PALETTE_SIZE			equ $20

PALETTE_EXT_RAM_START		equ $314000
PALETTE_EXT_RAM_SIZE		equ $800
PALETTE_EXT_RAM_ADDRESS_LINES	equ 11
PALETTE_EXT_RAM_MASK		equ $ff

SPRITE_RAM_START		equ $ffc000
SPRITE_RAM_SIZE			equ $800
SPRITE_RAM_ADDRESS_LINES	equ 11
SPRITE_RAM_MASK			equ $ffff

WORK_RAM_START			equ $ff8000
WORK_RAM_SIZE			equ $4000
WORK_RAM_ADDRESS_LINES		equ 14
WORK_RAM_MASK			equ $ffff

REG_TILE1_CTRL1			equ $240000
REG_TILE1_CTRL2			equ $240010
REG_TILE1_COLUMN_SCROLL		equ $242000
REG_TILE1_ROW_SCROLL		equ $242400
TILE1_RAM_START			equ $242000
TILE1_RAM_SIZE			equ $4000
TILE1_RAM_ADDRESS_LINES		equ 13
TILE1_RAM_MASK			equ $ffff

REG_TILE2_CTRL1			equ $246000
REG_TILE2_CTRL2			equ $246010
REG_TILE2_COLUMN_SCROLL		equ $248000
REG_TILE2_ROW_SCROLL		equ $248400
; Note: The 4k of ram is split up into 2x
; 2k blocks one starting at $248000 and the
; other at $24a000.  The first 2k block is
; mirrored 3 times.  By using last mirror
; ($249800) as our start address it makes
; the full 4k contiguous, which makes testing
; easier
TILE2_RAM_START			equ $249800
TILE2_RAM_SIZE			equ $1000
TILE2_RAM_ADDRESS_LINES		equ 11
TILE2_RAM_MASK			equ $ffff

REG_TILE3_CTRL1			equ $24c000
REG_TILE3_CTRL2			equ $24c010
REG_TILE3_COLUMN_SCROLL		equ $24c800
REG_TILE3_ROW_SCROLL		equ $24cc00
TILE3_RAM_START			equ $24c800
TILE3_RAM_SIZE			equ $1000
TILE3_RAM_ADDRESS_LINES		equ 11
TILE3_RAM_MASK			equ $ffff

REG_SOUND			equ $30c015
REG_IRQ6_ACK			equ $30c018

REG_INPUT_P1			equ $30c001
REG_INPUT_P2			equ $30c000
REG_INPUT_SYSTEM		equ $30c003
REG_INPUT_DSW1			equ $30c005
REG_INPUT_DSW2			equ $30c004

SYS_VBLANK_BIT			equ $7
SYS_VBLANK			equ $80

DSW1_SCREEN_FLIP		equ $40

CHAR_COLON			equ ':'

SOUND_NUM_STOP			equ $01

SCREEN_TILES_PER_LINE		equ 32
SCREEN_BYTES_PER_TILE		equ 2
SCREEN_BYTES_PER_LINE		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_LINE)


	macro SOUND_PLAY
		move.b	d0, REG_SOUND
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND
	endm

	macro WATCHDOG
	endm

	ifd _SCREEN_TATE_
		; in order to print a string, you have to put each char $40 bytes apart
		macro SEEK_XY
			lea	((TILE1_RAM_START + $207e + (\1 * SCREEN_BYTES_PER_LINE)) - (\2 * SCREEN_BYTES_PER_TILE)), a6
		endm

		macro SEEK_LN
			lea	((TILE1_RAM_START + $207e) - (\1 * SCREEN_BYTES_PER_TILE)), a6
		endm

	else
		; normal style printing
		macro SEEK_XY
			lea	(TILE1_RAM_START + $2040 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_LINE)), a6
		endm

		macro SEEK_LN
			lea	(TILE1_RAM_START + $2040 + (\1 * SCREEN_BYTES_PER_LINE)), a6
		endm
	endif
