ROM_SIZE			equ $8000
ROM_START			equ $8000

BAC06_RAM			equ $2000
BAC06_RAM_SIZE			equ $1000
BAC06_RAM_ADDRESS_LINES		equ 12

SPRITE_RAM			equ $3000
SPRITE_RAM_SIZE			equ $800
SPRITE_RAM_ADDRESS_LINES	equ 11

VIDEO_RAM			equ $1800
VIDEO_RAM_SIZE			equ $800
VIDEO_RAM_ADDRESS_LINES		equ 11

WORK_RAM			equ $0000
WORK_RAM_SIZE			equ $1800
WORK_RAM_ADDRESS_LINES		equ 11

FIX_TILE			equ VIDEO_RAM
FIX_TILE_SIZE			equ VIDEO_RAM_SIZE

REG_BAC06_SCROLL_X		equ $3830
REG_BAC06_SCROLL_Y		equ $3832
REG_SOUND			equ $3800
REG_CONTROL			equ $3840

CTRL_NMI			equ $02
CTRL_SPRITE_COPY		equ $04		; copy happens on 0 -> 1 of this bit
CTRL_SCREEN_FLIP		equ $08

REG_INPUT_P1			equ $3800
REG_INPUT_P2			equ $3801
REG_INPUT_P3			equ $3802
REG_INPUT_DSW1			equ $3803
REG_INPUT_DSW2			equ $3820

DSW1_SCREEN_FLIP		equ $40
DSW1_VBLANK			equ $08

CHAR_COLON			equ ':'

	macro	WATCHDOG
	endm

	macro	SOUND_PLAY
		sta	REG_SOUND
	endm

	macro	SOUND_STOP
		lda	#$1
		sta	REG_SOUND
	endm
