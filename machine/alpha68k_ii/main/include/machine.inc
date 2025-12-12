	include "romset.inc"

TILE_RAM			equ $100000
TILE_RAM_SIZE			equ $1000
TILE_RAM_ADDRESS_LINES		equ 12
TILE_RAM_MASK			equ $ff
TILE_PALETTE			equ PALETTE_RAM

PALETTE_RAM			equ $400000
PALETTE_RAM_MASK		equ $ffff
PALETTE_RAM_SIZE		equ $1000
PALETTE_RAM_ADDRESS_LINES	equ 12
PALETTE_SIZE			equ $20		; size of an individual palette

SPRITE_RAM			equ $200000
SPRITE_RAM_SIZE			equ $8000
SPRITE_RAM_ADDRESS_LINES	equ 14
SPRITE_RAM_MASK			equ $ff
; Sprites can access any palette in the palette ram.
; Adding $100 so we dont accidently conflict with tile's
; palettte.  When setting up sprites need to start at
; palette $8.
SPRITE_PALETTE			equ PALETTE_RAM + $100

WORK_RAM			equ $040000
WORK_RAM_SIZE			equ $1000
WORK_RAM_ADDRESS_LINES		equ 12
WORK_RAM_MASK			equ $ffff

ROM_START			equ $000000
ROM_SIZE			equ $20000

REG_SOUND			equ $080001
REG_IRQ1_ACK			equ $0e0000
REG_IRQ3_ACK			equ $0d8000
REG_WATCHDOG			equ $0e8000
REG_MCU_DSW2			equ $300000
REG_LATCH_BANK_BIT0		equ $0c0021
REG_LATCH_BANK_BIT1		equ $0c0029
REG_LATCH_BANK_BIT2		equ $0c0031

REG_INPUT_P1			equ $080001
REG_INPUT_P2			equ $080000
REG_INPUT_DSW1			equ $0c0001
REG_INPUT_DSW2			equ $040001

CHAR_COLON			equ ':'

SOUND_NUM_STOP			equ $0f

	macro SOUND_PLAY
		move.b	d0, REG_SOUND
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND
	endm

	macro WATCHDOG
		tst.b	REG_WATCHDOG
	endm
