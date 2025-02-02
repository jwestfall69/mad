SP_INIT_ADDR			equ WORK_RAM_START + WORK_RAM_SIZE
;SP_INIT_ADDR			equ $ff8000
MAD_ROM_SIZE			equ $8000

PALETTE_TEXT_COLOR		equ $ffff
PALETTE_TEXT_SHADOW_COLOR	equ $2222
PALETTE_BACKGROUND_COLOR	equ $0

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $3
; tile defines are in the romsets
