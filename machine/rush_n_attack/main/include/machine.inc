ROM_START			equ $0
ROM_SIZE			equ $4000

PALETTE_RAM			equ $c000
PALETTE_RAM_SIZE		equ $800
PALETTE_RAM_ADDRESS_LINES	equ 11
PALETTE_SIZE			equ $20

SPRITE_RAM			equ $d000
SPRITE_RAM_SIZE			equ $200
SPRITE_RAM_ADDRESS_LINES	equ 9

TILE_RAM			equ $c800
TILE_RAM_SIZE			equ $800
TILE_RAM_ADDRESS_LINES		equ 11

TILE_ATTR_RAM			equ $c000
TILE_ATTR_RAM_SIZE		equ $800
TILE_ATTR_RAM_ADDRESS_LINES	equ 11

WORK_RAM_CHIP			equ $c000
WORK_RAM_CHIP_SIZE		equ $2000
WORK_RAM_CHIP_ADDRESS_LINES	equ 13

WORK_RAM			equ $d200
WORK_RAM_SIZE			equ $300

REG_WATCHDOG			equ $f600

REG_SOUND_LATCH			equ $f200
REG_SOUND_TRIGGER		equ $f400

REG_INPUT_P1			equ $f602
REG_INPUT_P2			equ $f601
REG_INPUT_DSW1			equ $f600
REG_INPUT_DSW2			equ $f200
REG_INPUT_DSW3			equ $f400
REG_INPUT_SYS			equ $f603

CHAR_COLON			equ $10		; no colon char, using space

	macro WATCHDOG
		ld	(REG_WATCHDOG), a
	endm

	; we are only allowed to use a/de registers
	macro SOUND_PLAY
		ld	d, a
		srl	a
		srl	a
		srl	a
		srl	a
		or	a, $80
		ld	(REG_SOUND_LATCH), a
		ld	(REG_SOUND_TRIGGER), a
		nop
		nop
		nop
		nop
		nop
		nop
		ld	a, d
		and	a, $f
		ld	(REG_SOUND_LATCH), a
		ld	(REG_SOUND_TRIGGER), a
		nop
		nop
		nop
		nop
		nop
		nop
		ld	a, $93
		ld	(REG_SOUND_LATCH), a
		ld	(REG_SOUND_TRIGGER), a
	endm

	macro SOUND_STOP
		ld	a, $9f
		ld	(REG_SOUND_LATCH), a
		ld	(REG_SOUND_TRIGGER), a
	endm
