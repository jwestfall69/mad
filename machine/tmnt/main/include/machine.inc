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
SPRITE_PALETTE			equ PALETTE_RAM + $400

TILE_RAM			equ $100000
TILE_RAM_SIZE			equ $6000
TILE_RAM_ADDRESS_LINES		equ 13
TILE_RAM_MASK			equ $ffff

; K052109 tile stuff
; offsets are screwy because the game doesn't have A12
; hooked up to the ic
K052109_BASE			equ $100000

FIX_TILE			equ K052109_BASE
FIX_TILE_SIZE			equ $1000
FIX_TILE_PALETTE		equ PALETTE_RAM

LAYER_A_TILE			equ K052109_BASE + $2000
LAYER_A_TILE_SIZE		equ $1000
LAYER_A_TILE_PALETTE		equ PALETTE_RAM + $800
; high byte only
LAYER_A_SCROLL			equ K052109_BASE + $6000
LAYER_A_SCROLL_SIZE		equ $400

LAYER_B_TILE			equ K052109_BASE + $4000
LAYER_B_TILE_SIZE		equ $1000
LAYER_B_TILE_PALETTE		equ PALETTE_RAM + $a00
; lower byte only
LAYER_B_SCROLL			equ K052109_BASE + $6001
LAYER_B_SCROLL_SIZE		equ $400

; K052109 registers
REG_LAYER_A_SCROLL_X_LOW	equ K052109_BASE + $6400
REG_LAYER_A_SCROLL_X_HIGH	equ K052109_BASE + $6402
REG_LAYER_A_SCROLL_Y		equ K052109_BASE + $6018

REG_LAYER_B_SCROLL_X_LOW	equ K052109_BASE + $6401
REG_LAYER_B_SCROLL_X_HIGH	equ K052109_BASE + $6403
REG_LAYER_B_SCROLL_Y		equ K052109_BASE + $6019

; A tile can point at 1 of 4 bank slots, with
; each bank slot being able to point at 1 of
; 16 tile rom banks
REG_TILE_BANK_SLOTS_A		equ K052109_BASE + $6b00	; 0000 1111 - bank slots 0 and 1
REG_TILE_BANK_SLOTS_B		equ K052109_BASE + $6e00	; 2222 3333 - bank slots 2 and 3

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

