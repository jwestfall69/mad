MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $aa
CURSOR_CLEAR_CHAR	equ $fe

SOUND_NUM_SUCCESS	equ $21
SOUND_NUM_BIT_ZERO	equ $0f ; insert coin?
SOUND_NUM_BIT_ONE	equ $11	; camera shutter


	macro SOUND_BIT_DELAY
		lda	#$7f

	.\@:
		WATCHDOG
		ldw	#$1ff
		PSUB	delay
		deca
		bne	.\@
	endm
