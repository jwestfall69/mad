	include "romset.inc"

ROM_BASE			equ $000000
ROM_SIZE			equ $20000

; RAM CHIPS
PALETTE_RC_BASE			equ $400000
PALETTE_RC_SIZE			equ $1000
PALETTE_RC_ADDR_LINES		equ 12
PALETTE_RC_MASK			equ $ffff

SPRITE_RC_BASE			equ $100000
SPRITE_RC_SIZE			equ $8000
SPRITE_RC_ADDR_LINES		equ 14
SPRITE_RC_MASK			equ $ff

TILE_RC_BASE			equ $200000
TILE_RC_SIZE			equ $1000
TILE_RC_ADDR_LINES		equ 12
TILE_RC_MASK			equ $ffff

WORK_RC_BASE			equ $040000
WORK_RC_SIZE			equ $1000
WORK_RC_ADDR_LINES		equ 12
WORK_RC_MASK			equ $ffff

; MEMORY REGIONS
PALETTE_BASE			equ PALETTE_RC_BASE
PALETTE_SIZE			equ PALETTE_RC_SIZE
PALETTE_ENTRY_SIZE		equ $20

SPRITE_BASE			equ SPRITE_RC_BASE
SPRITE_SIZE			equ SPRITE_RC_SIZE
; Sprites can access any palette in the palette ram.
; Adding $100 so we dont accidently conflict with tile's
; palettte.  When setting up sprites need to start at
; palette $8.
SPRITE_PALETTE_BASE		equ PALETTE_BASE + $100

TILE_BASE			equ TILE_RC_BASE
TILE_SIZE			equ TILE_RC_SIZE
TILE_PALETTE_BASE		equ PALETTE_BASE

WORK_RAM_BASE			equ WORK_RC_BASE
WORK_RAM_SIZE			equ WORK_RC_SIZE

; REG/IO
REG_SOUND			equ $080000
REG_IRQ1_ACK			equ $0e0000

REG_INPUT_P1			equ $080001
REG_INPUT_P2			equ $080003
REG_INPUT_SYS			equ $080005
REG_INPUT_DSW1			equ $0f0001
REG_INPUT_DSW2			equ $0f0009

CHAR_COLON			equ ':'

SOUND_NUM_STOP			equ $01
SOUND_NUM_START			equ $0d

	macro WATCHDOG
	endm

	macro SOUND_PLAY
		move.b	d0, REG_SOUND
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND
		move.l	#$fff, d0
		DSUB	delay
		move.b	#SOUND_NUM_STOP, REG_SOUND
	endm
