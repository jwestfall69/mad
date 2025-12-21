MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0b	; (c)
CURSOR_CLEAR_CHAR	equ $0

SOUND_NUM_SUCCESS	equ $15
SOUND_NUM_BIT_ZERO	equ $8
SOUND_NUM_BIT_ONE	equ $5

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ FG_RAM

	; we are only allowed to use d register
	macro SOUND_BIT_DELAY
		ldd	#$ffff
	.\@:
		WATCHDOG
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		subd	#$1
		bne	.\@		; 2 cycles
	endm
