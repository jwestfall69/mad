ROM_SIZE			equ $8000
ROM_START			equ $8000

; note
; B8 ram chip on graphics board is 0x0000 to 0x07ff
; B11 ram chip on cpu board is 0x0800 to 0xfff
; B14 ram chip on graphics board is 0x1000 to 0x1100 (the rest of the space to 0x17ff is mirrors)

BG_RAM				equ $0c00
BG_RAM_SIZE			equ $0400

FG_RAM				equ $0000
FG_RAM_SIZE			equ $0800
FG_RAM_ADDRESS_LINES		equ 11

SPRITE_RAM			equ $1000
SPRITE_RAM_SIZE			equ $100
SPRITE_RAM_ADDRESS_LINES	equ 8

WORK_RAM			equ $0800
WORK_RAM_SIZE			equ $0400

WORK_RAM_CHIP			equ $0800
WORK_RAM_CHIP_SIZE		equ $800
WORK_RAM_CHIP_ADDRESS_LINES	equ 11

REG_CONTROL1			equ $1801
REG_CONTROL2			equ $1803
REG_SOUND			equ $1802

CTRL2_NMI_DISABLE		equ $0
CTRL2_NMI_ENABLE		equ $2
CTRL2_IRQ_DISABLE		equ $1
CTRL2_IRQ_ENABLE		equ $0

REG_INPUT_P1			equ $1800
REG_INPUT_P2			equ $1801
REG_INPUT_DSW1			equ $1802
REG_INPUT_DSW2			equ $1803

INPUT_P2_VBLANK			equ $80

CHAR_COLON			equ $05

	macro	WATCHDOG
	endm

	macro	SOUND_PLAY
		sta	REG_SOUND
	endm

	macro	SOUND_STOP
		clra
		sta	REG_SOUND
	endm
