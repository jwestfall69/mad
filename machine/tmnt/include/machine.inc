WORK_RAM_START			equ $060000
WORK_RAM_SIZE			equ $4000
WORK_RAM_ADDRESS_LINES		equ 14
WORK_RAM_MASK			equ $ffff

PALETTE_RAM_START		equ $080000
PALETTE_RAM_SIZE		equ $1000
PALETTE_RAM_ADDRESS_LINES	equ 12
PALETTE_RAM_MASK		equ $ff

TILE_RAM_START		equ $100000
TILE_RAM_SIZE		equ $6000


ROM_START		equ $000000
ROM_SIZE		equ $40000

REG_SOUND		equ $0a0009

REG_INPUT_DSW1		equ $0a0011
REG_INPUT_DSW2		equ $0a0013
REG_INPUT_DSW3		equ $0a0019
REG_INPUT_P1		equ $0a0003
REG_INPUT_P2		equ $0a0005
REG_INPUT_P3		equ $0a0007
REG_INPUT_P4		equ $0a0015
REG_INPUT_SYSTEM	equ $0a0001

P1_LEFT_BIT		equ $0
P1_RIGHT_BIT		equ $1
P1_UP_BIT		equ $2
P1_DOWN_BIT		equ $3
P1_B1_BIT		equ $4
P1_B2_BIT		equ $5

P1_LEFT			equ $01
P1_RIGHT		equ $02
P1_UP			equ $04
P1_DOWN			equ $08
P1_B1			equ $10
P1_B2			equ $20

P2_LEFT_BIT		equ $0
P2_RIGHT_BIT		equ $1
P2_UP_BIT		equ $2
P2_DOWN_BIT		equ $3
P2_B1_BIT		equ $4
P2_B2_BIT		equ $5

P2_LEFT			equ $01
P2_RIGHT		equ $02
P2_UP			equ $04
P2_DOWN			equ $08
P2_B1			equ $10
P2_B2			equ $20

SYS_COIN1_BIT		equ $0
SYS_COIN2_BIT		equ $1
SYS_COIN3_BIT		equ $2
SYS_COIN4_BIT		equ $3
SYS_SERVICE1_BIT	equ $4
SYS_SERVICE2_BIT	equ $5
SYS_SERVICE3_BIT	equ $6
SYS_SERVICE4_BIT	equ $7

SYS_COIN1		equ $01
SYS_COIN2		equ $02
SYS_COIN3		equ $04
SYS_COIN4		equ $08
SYS_SERVICE1		equ $10
SYS_SERVICE2		equ $20
SYS_SERVICE3		equ $40
SYS_SERVICE4		equ $80

CHAR_COLON		equ $40

SOUND_NUM_STOP		equ $ff

	macro SEEK_XY
		lea	(TILE_RAM_START + $118 + (\1 * 2) + (\2 * 128)), a6
	endm

	macro SEEK_LN
		lea	(TILE_RAM_START + $118 + (\1 * 128)), a6
	endm

	macro WATCHDOG
		move.b d0, $a0011
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

