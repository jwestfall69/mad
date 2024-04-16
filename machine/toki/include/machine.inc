; There are 2x 32kx8bit sram that everything
; uses on the 68k ram
RAM_START		equ $060000
RAM_SIZE		equ $010000
RAM_ADDRESS_LINES	equ 15

NOT_WORK_RAM_START	equ $06d800
NOT_WORK_RAM_SIZE	equ $2800

WORK_RAM_START		equ $060000
SPRITE_RAM_START	equ $06d800
BG1_RAM_START		equ $06e800
BG2_RAM_START		equ $06f000

FG_RAM_START		equ $06f800
FG_RAM_SIZE		equ $800

PALETTE_RAM_START	equ $06e000
PALETTE_RAM_SIZE	equ $800

SCROLL_RAM_SART		equ $0a0000
SCROLL_RAM_SIZE		equ $d

ROM_START		equ $000000
ROM_SIZE		equ $40000

; the hardware doesn't seem to update video output
; unless a write happens to this address
MMIO_SCREEN_UPDATE	equ $0a0040
MMIO_SCREEN_FLIP	equ $0a0050

REG_INPUT_DSW1		equ $0c0001
REG_INPUT_DSW2		equ $0c0000
REG_INPUT_P1		equ $0c0003
REG_INPUT_P2		equ $0c0002
REG_INPUT_SYSTEM	equ $0c0005

P1_UP_BIT		equ $0
P1_DOWN_BIT		equ $1
P1_LEFT_BIT		equ $2
P1_RIGHT_BIT		equ $3
P1_B1_BIT		equ $4
P1_B2_BIT		equ $5

P1_UP			equ $01
P1_DOWN			equ $02
P1_LEFT			equ $04
P1_RIGHT		equ $08
P1_B1			equ $10
P1_B2			equ $20

P2_UP_BIT		equ $0
P2_DOWN_BIT		equ $1
P2_LEFT_BIT		equ $2
P2_RIGHT_BIT		equ $3
P2_B1_BIT		equ $4
P2_B2_BIT		equ $5

P2_UP			equ $01
P2_DOWN			equ $02
P2_LEFT			equ $04
P2_RIGHT		equ $08
P2_B1			equ $10
P2_B2			equ $20

SYS_SERVICE_BIT		equ $2
SYS_START1_BIT		equ $3
SYS_START2_BIT		equ $4

SYS_SERVICE		equ $04
SYS_START1		equ $08
SYS_START2		equ $10

DSW1_FLIP_SCREEN_BIT	equ $7
DSW1_FLIP_SCREEN	equ $80

	macro SCREEN_UPDATE
		move.w	d0, MMIO_SCREEN_UPDATE
	endm

	macro SEEK_XY
		lea	(FG_RAM_START + 128 + (\1 * 2) + (\2 * 64)), a6
	endm

	macro SEEK_LN
		lea	(FG_RAM_START + 128  + (\1 * 64)), a6
	endm

	macro ENABLE_INTS
		move.w	#$2000, sr
	endm

	macro DISABLE_INTS
		move.w	#$2700, sr
	endm
