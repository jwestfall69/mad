BG_RAM				equ $080000
BG_RAM_SIZE			equ $4000
BG_RAM_ADDRESS_LINES		equ 14
BG_RAM_MASK			equ $ffff

BG2_RAM				equ $082000

FG_RAM				equ $0c0000
FG_RAM_SIZE			equ $2000
FG_SPRITE_RAM			equ $0c0000
FG_SPRITE_RAM_SIZE		equ $4000
FG_SPRITE_RAM_ADDRESS_LINES	equ 14
FG_SPRITE_RAM_MASK		equ $ff

PALETTE_RAM			equ $180000
PALETTE_RAM_SIZE		equ $10000	; address space, not size (2k)
PALETTE_RAM_ADDRESS_LINES	equ 16
PALETTE_RAM_MASK		equ $ffff
PALETTE_SIZE			equ $80		; size of individual palette

SPRITE_RAM			equ $0c2000

WORK_RAM			equ $1c0000
WORK_RAM_SIZE			equ $4000
WORK_RAM_ADDRESS_LINES		equ 14
WORK_RAM_MASK			equ $ffff

ROM_START			equ $000000
	ifd _27C010_
ROM_SIZE			equ $40000
	else
ROM_SIZE			equ $80000
	endif

REG_SOUND			equ $14000d
REG_SCREEN_PRIORITY		equ $140011
REG_IRQ2_ACK			equ $140002
REG_IRQ3_ACK			equ $140000
REG_WATCHDOG			equ $140016

REG_INPUT_P1			equ $140021
REG_INPUT_P2			equ $140023
REG_INPUT_P3			equ $140025
REG_INPUT_P4			equ $140027
REG_INPUT_DSW1			equ $140020
REG_INPUT_DSW2			equ $140022
REG_INPUT_DSW3			equ $140024
REG_INPUT_SYSTEM		equ $140026

SYS_VBLANK_BIT			equ $2
SYS_VBLANK			equ $04

CHAR_COLON			equ '@'

SOUND_NUM_STOP			equ $00

SCREEN_TILES_PER_LINE		equ 64	; only 40 are on screen at a time
SCREEN_BYTES_PER_TILE		equ 4
SCREEN_BYTES_PER_LINE		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_LINE)

	; goto the correct fg memory location before printing text
	; to the screen
	macro SEEK_XY
		lea	(FG_RAM + $100 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_LINE)), a6
	endm

	macro SEEK_LN
		lea	(FG_RAM + $100 + (\1 * SCREEN_BYTES_PER_LINE)), a6
	endm

	macro SOUND_PLAY
		move.b	d0, REG_SOUND
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND
	endm

	macro WATCHDOG
		clr.w	REG_WATCHDOG
	endm
