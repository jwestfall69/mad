BG_RAM_START		equ $0c0000
BG_RAM_SIZE		equ $1000

FG_RAM_START		equ $080000
FG_RAM_SIZE		equ $1000
FG_RAM_ADDRESS_LINES    equ 11

PALETTE_RAM_START	equ $140000
;PALETTE_RAM_SIZE	equ $1000
PALETTE_RAM_SIZE	equ $300

SPRITE_RAM_START	equ $100000
SPRITE_RAM_SIZE		equ $4000

WORK_RAM_START		equ $1c0000
WORK_RAM_SIZE		equ $4000
WORK_RAM_ADDRESS_LINES	equ 13

ROM_START		equ $000000
ROM_SIZE		equ $40000

REG_INPUT_P1		equ $180005
REG_INPUT_P2		equ $180007
REG_INPUT_DSW1		equ $180001
REG_INPUT_DSW2		equ $180003
REG_INPUT_SYSTEM	equ $180009

P1_RIGHT_BIT		equ $0
P1_LEFT_BIT		equ $1
P1_UP_BIT		equ $2
P1_DOWN_BIT		equ $3
P1_B1_BIT		equ $4
P1_B2_BIT		equ $5
P1_A_BIT		equ $7 		; Button A (1P VS CPU - Power Up)

P1_RIGHT		equ $01
P1_LEFT			equ $02
P1_UP			equ $04
P1_DOWN			equ $08
P1_B1			equ $10
P1_B2			equ $20
P1_A			equ $80

P2_RIGHT_BIT		equ $0
P2_LEFT_BIT		equ $1
P2_UP_BIT		equ $2
P2_DOWN_BIt		equ $3
P2_B1_BIT		equ $4
P2_B2_BIT		equ $5
P2_C_BIT		equ $6		; Button C (1P/2P VS CPU)
P2_B_BIT		equ $7		; Button B (1P VS 2P - Buy-in)

P2_RIGHT		equ $01
P2_LEFT			equ $02
P2_UP			equ $04
P2_DOWN			equ $08
P2_B1			equ $10
P2_B2			equ $20
P2_C			equ $40
P2_B			equ $80

SYS_VBLANK_BIT		equ $0
SYS_COIN1_BIT		equ $1
SYS_COIN2_BIT		equ $2
SYS_SERVICE_BIT		equ $3

SYS_VBLANK		equ $01
SYS_COIN1		equ $02
SYS_COIN2		equ $04
SYS_SERVICE		equ $08

DSW1_FLIP_SCREEN_BIT	equ $7
DSW1_FLIP_SCREEN	equ $80

	; goto the correct fg memory location before printing text
	; to the screen
	macro SEEK_XY
		lea	(FG_RAM_START + $80 + (\1 * 4) + (\2 * 32 * 4)), a6
	endm

	macro SEEK_LN
		lea	(FG_RAM_START + $80 +  + (\1 * 32 * 4)), a6
	endm