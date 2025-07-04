WORK_RAM			equ $2000
WORK_RAM_SIZE			equ $1b00
WORK_RAM_ADDRESS_LINES		equ 12

; bank switched into work ram space
PALETTE_RAM			equ $1800
PALETTE_RAM_SIZE		equ $800
PALETTE_RAM_ADDRESS_LINES	equ 11
PALETTE_SIZE			equ $20

SPRITE_RAM			equ $1000
SPRITE_RAM_SIZE			equ $800
SPRITE_RAM_ADDRESS_LINES	equ 11
SPRITE_PALETTE			equ PALETTE_RAM + $200

TILE_RAM			equ $800
TILE_RAM_SIZE			equ $800
TILE_RAM_ADDRESS_LINES		equ 11
TILE_PALETTE			equ PALETTE_RAM

ROM_SIZE			equ $8000
ROM_START			equ $8000

REG_INPUT_P1			equ $0050
REG_INPUT_P2			equ $0051
REG_INPUT_DSW1			equ $0053
REG_INPUT_DSW2			equ $0060
REG_INPUT_DSW3			equ $0053

REG_WATCHDOG			equ $0020
REG_SOUND			equ $0030
REG_SOUND_IRQ_TRIGGER		equ $0040
REG_SPRITE_REFRESH		equ $0306

CHAR_COLON			equ $10		; no colon char, using space

	macro	WATCHDOG
		tst	REG_WATCHDOG
	endm

	macro	SOUND_PLAY
		sta	REG_SOUND
		clr	REG_SOUND + 1
		sta	REG_SOUND_IRQ_TRIGGER
	endm

	macro	SOUND_STOP
		clr	REG_SOUND
		clr	REG_SOUND + 1
		sta	REG_SOUND_IRQ_TRIGGER
	endm
