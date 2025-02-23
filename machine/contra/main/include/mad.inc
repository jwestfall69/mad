MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0f
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $4d
SOUND_NUM_BIT_ZERO	equ $07 ; ?
SOUND_NUM_BIT_ONE	equ $13	; insert coin?

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ PALETTE_RAM_START

	macro SOUND_BIT_DELAY
		lda	#$7f

	.\@:
		WATCHDOG
		ldw	#$1ff
		PSUB	delay
		deca
		bne	.\@
	endm
