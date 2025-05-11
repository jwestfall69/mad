WORK_RAM			equ $060000
WORK_RAM_SIZE			equ $4000
WORK_RAM_ADDRESS_LINES		equ 14
WORK_RAM_MASK			equ $ffff

PALETTE_RAM			equ $080000
PALETTE_RAM_SIZE		equ $1000
PALETTE_RAM_ADDRESS_LINES	equ 12
PALETTE_RAM_MASK		equ $ff
PALETTE_SIZE			equ $40

SPRITE_RAM			equ $140400
SPRITE_RAM_SIZE			equ $400
SPRITE_RAM_ADDRESS_LINES	equ 9
SPRITE_RAM_MASK			equ $ffff

TILE_RAM			equ $100000
TILE_RAM_SIZE			equ $6000
TILE_RAM_ADDRESS_LINES		equ 13
TILE_RAM_MASK			equ $ffff

ROM_START			equ $000000
ROM_SIZE			equ $40000

REG_SOUND			equ $0a0009
REG_WATCHDOG			equ $0a0011

REG_INPUT_DSW1			equ $0a0011
REG_INPUT_DSW2			equ $0a0013
REG_INPUT_DSW3			equ $0a0019
REG_INPUT_P1			equ $0a0003
REG_INPUT_P2			equ $0a0005
REG_INPUT_P3			equ $0a0007
REG_INPUT_P4			equ $0a0015
REG_INPUT_SYSTEM		equ $0a0001

CHAR_COLON			equ $40

SOUND_NUM_STOP			equ $ff

SCREEN_TILES_PER_LINE		equ 64	; only 32 visible at a time?
SCREEN_BYTES_PER_TILE		equ 2
SCREEN_BYTES_PER_LINE		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_LINE)

	macro SEEK_XY
		lea	(TILE_RAM + $118 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_LINE)), a6
	endm

	macro SEEK_LN
		lea	(TILE_RAM + $118 + (\1 * SCREEN_BYTES_PER_LINE)), a6
	endm

	macro WATCHDOG
		move.b d0, REG_WATCHDOG
	endm

	macro SOUND_PLAY
		move.b	d0, REG_SOUND
		; transitioning this bit from high to low
		; will trigger an irq on the sound cpu.
		; need to clean this up a little, the number
		; of nops is just randomly picked
		move.b	#$8, $a0001
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		move.b	#$0, $a0001
	endm

	macro SOUND_STOP
		move.b	#$0, d0
		SOUND_PLAY
	endm

