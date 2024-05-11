BG_RAM_START			equ $080000
BG_RAM_SIZE			equ $4000
BG_RAM_ADDRESS_LINES		equ 14
BG_RAM_MASK			equ $ffff

BG2_RAM_START			equ $082000

FG_RAM_START			equ $0c0000
FG_SPRITE_RAM_START		equ $0c0000
FG_SPRITE_RAM_SIZE		equ $4000
FG_SPRITE_RAM_ADDRESS_LINES	equ 14
FG_SPRITE_RAM_MASK		equ $ff

PALETTE_RAM_START		equ $180000
PALETTE_RAM_SIZE		equ $fffe
PALETTE_RAM_ADDRESS_LINES	equ 11
;PALETTE_RAM_SIZE		equ $2000
;PALETTE_RAM_ADDRESS_LINES	equ 13
PALETTE_RAM_MASK		equ $ffff

SPRITE_RAM_START		equ $0c2000

WORK_RAM_START			equ $1c0000
WORK_RAM_SIZE			equ $4000
WORK_RAM_ADDRESS_LINES		equ 14
WORK_RAM_MASK			equ $ffff

ROM_START			equ $000000
ROM_SIZE			equ $80000

REG_SOUND			equ $14000d
REG_SCREEN_PRIORITY		equ $140011
REG_IRQ2_ACK			equ $140002
REG_IRQ3_ACK			equ $140000

REG_INPUT_P1			equ $140021
REG_INPUT_P2			equ $140023
REG_INPUT_P3			equ $140025
REG_INPUT_P4			equ $140027
REG_INPUT_DSW1			equ $140020
REG_INPUT_DSW2			equ $140022
REG_INPUT_DSW3			equ $140024
REG_INPUT_SYSTEM		equ $140026

P1_RIGHT_BIT			equ $0
P1_LEFT_BIT			equ $1
P1_UP_BIT			equ $2
P1_DOWN_BIT			equ $3
P1_B1_BIT			equ $4
P1_B2_BIT			equ $5
P1_START_BIT			equ $7

P1_RIGHT			equ $01
P1_LEFT				equ $02
P1_UP				equ $04
P1_DOWN				equ $08
P1_B1				equ $10
P1_B2				equ $20
P1_START			equ $80

P2_RIGHT_BIT			equ $0
P2_LEFT_BIT			equ $1
P2_UP_BIT			equ $2
P2_DOWN_BIT			equ $3
P2_B1_BIT			equ $4
P2_B2_BIT			equ $5
P2_START_BIT			equ $7

P2_RIGHT			equ $01
P2_LEFT				equ $02
P2_UP				equ $04
P2_DOWN				equ $08
P2_B1				equ $10
P2_B2				equ $20
P2_START			equ $80

SYS_VBLANK_BIT			equ $2
SYS_VBLANK			equ $04
SYS_START1			equ $80

SOUND_NUM_STOP			equ $00

	; goto the correct fg memory location before printing text
	; to the screen
	macro SEEK_XY
		lea	(FG_RAM_START + $100 + (\1 * 4) + (\2 * 64 * 4)), a6
	endm

	macro SEEK_LN
		lea	(FG_RAM_START + $100 + (\1 * 64 * 4)), a6
	endm

	macro SOUND_PLAY
		move.b	d0, REG_SOUND
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND
	endm
