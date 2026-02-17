	; raw delay without using any function/dsub.
	; Using de here so we can use this in SOUND_BIT_DELAY
	macro DELAY
		ld	de, \1
	.\@:
		WATCHDOG		; ??
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		dec	de		; 6 cycles
		ld	a, e		; 4 cycles
		or	d		; 4 cycles
		jr	nz, .\@		; 12 cycles

	endm

	macro STALL
	.\@:
		WATCHDOG
		jp .\@
	endm
