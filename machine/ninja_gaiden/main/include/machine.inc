WORK_RAM			equ $060000
WORK_RAM_SIZE			equ $4000
WORK_RAM_ADDRESS_LINES		equ 13
WORK_RAM_MASK			equ $ffff

TXT_RAM				equ $070000
TXT_RAM_SIZE			equ $1000
TXT_RAM_ADDRESS_LINES		equ 11
TXT_RAM_MASK			equ $ffff

FG_RAM				equ $072000
FG_RAM_SIZE			equ $2000
FG_RAM_ADDRESS_LINES		equ 12
FG_RAM_MASK			equ $ffff

BG_RAM				equ $074000
BG_RAM_SIZE			equ $2000
BG_RAM_ADDRESS_LINES		equ 12
BG_RAM_MASK			equ $ffff

PALETTE_RAM			equ $078000
PALETTE_RAM_SIZE		equ $2000
PALETTE_RAM_ADDRESS_LINES	equ 12
PALETTE_RAM_MASK		equ $0fff
PALETTE_SIZE			equ $20		; size of individual palette

SPRITE_RAM			equ $076000
; mame has the size as $2000, but if you try to accesss
; the upper $1000 the board will reboot/watchdog
SPRITE_RAM_SIZE			equ $1000
SPRITE_RAM_ADDRESS_LINES	equ 11
SPRITE_RAM_MASK			equ $ffff

ROM_START			equ $000000
ROM_SIZE			equ $20000

REG_SOUND1			equ $07a803
REG_WATCHDOG			equ $07a800
REG_IRQ5_ACK			equ $07a806

REG_INPUT_DSW1			equ $07a005
REG_INPUT_DSW2			equ $07a004
REG_INPUT_P1			equ $07a003
REG_INPUT_P2			equ $07a002
REG_INPUT_SYSTEM		equ $07a001

CHAR_COLON			equ ' '

SOUND_NUM_STOP			equ $ff

	macro SOUND_PLAY
		move.b	d0, REG_SOUND1
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND1
	endm

	macro WATCHDOG
		move.w	d0, REG_WATCHDOG
	endm
