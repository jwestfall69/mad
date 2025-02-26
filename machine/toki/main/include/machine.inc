; There are 2x 32kx8bit sram that everything
; uses on the 68k ram
RAM_START			equ $060000
RAM_SIZE			equ $10000
RAM_ADDRESS_LINES		equ 16
RAM_MASK			equ $ffff

NOT_WORK_RAM_START		equ $06d800
NOT_WORK_RAM_SIZE		equ $2800

WORK_RAM_START			equ $060000
WORK_RAM_SIZE			equ $c000
SPRITE_RAM_START		equ $06d800
BG1_RAM_START			equ $06e800
BG2_RAM_START			equ $06f000

FG_RAM_START			equ $06f800
FG_RAM_SIZE			equ $800

PALETTE_RAM_START		equ $06e000
PALETTE_RAM_SIZE		equ $800
PALETTE_SIZE			equ $20		; size of individual palette

SCROLL_RAM_SART			equ $0a0000
SCROLL_RAM_SIZE			equ $d

ROM_START			equ $000000
ROM_SIZE			equ $40000

; the hardware doesn't seem to update video output
; unless a write happens to this address
MMIO_SCREEN_UPDATE		equ $0a0040
MMIO_SCREEN_FLIP		equ $0a0050

REG_SOUND1			equ $080000
REG_SOUND2			equ $080002
REG_SOUND3			equ $080004
REG_SOUND4			equ $080006
REG_SOUND5			equ $080008
REG_SOUND6			equ $08000a
REG_SOUND7			equ $08000c

REG_INPUT_DSW1			equ $0c0001
REG_INPUT_DSW2			equ $0c0000
REG_INPUT_P1			equ $0c0003
REG_INPUT_P2			equ $0c0002
REG_INPUT_SYSTEM		equ $0c0005

SYS_SERVICE_BIT			equ $2
SYS_START1_BIT			equ $3
SYS_START2_BIT			equ $4

SYS_SERVICE			equ $04
SYS_START1			equ $08
SYS_START2			equ $10

DSW1_FLIP_SCREEN_BIT		equ $7
DSW1_FLIP_SCREEN		equ $80

CHAR_COLON			equ ':'

SOUND_NUM_STOP			equ $ff


SCREEN_TILES_PER_LINE		equ 32
SCREEN_BYTES_PER_TILE		equ 2
SCREEN_BYTES_PER_LINE		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_LINE)

	macro SEEK_XY
		lea	(FG_RAM_START + 128 + (\1 * SCREEN_BYTES_PER_TILE) + (\2 * SCREEN_BYTES_PER_LINE)), a6
	endm

	macro SEEK_LN
		lea	(FG_RAM_START + 128 + (\1 * SCREEN_BYTES_PER_LINE)), a6
	endm


	macro SCREEN_UPDATE
		move.w	d0, MMIO_SCREEN_UPDATE
	endm

	; its unclear what sending #$80/$82 is doing
	macro SOUND_PLAY
		move.w	d0, REG_SOUND1
		move.w	#$80, REG_SOUND2
		move.w	#$80, REG_SOUND7
		move.w	#$80, REG_SOUND5
	endm

	macro SOUND_STOP
		move.w	#SOUND_NUM_STOP, REG_SOUND1
		move.w	#$82, REG_SOUND2
		move.w	#$82, REG_SOUND7
		move.w	#$82, REG_SOUND5
	endm

	macro WATCHDOG
	endm
