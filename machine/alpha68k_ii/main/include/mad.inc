SP_INIT_ADDR		equ WORK_RAM_START + WORK_RAM_SIZE
MAD_ROM_SIZE		equ $8000

PALETTE_TEXT_COLOR		equ $0fff
PALETTE_TEXT_SHADOW_COLOR	equ $0222

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		moveq	#$7f, d1
	.\@:
		WATCHDOG
		move.l	#$fff, d0
		DSUB	delay
		dbra	d1, .\@
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
; tile defines are in the romsets
