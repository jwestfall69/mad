	macro STRING
		dc.b \1, $0
		align 2
	endm

	macro STALL
.\@
		WATCHDOG
	ifd _STALL_DELAY_
		move.l	#$1fff, d0
		DSUB	delay
	endif
		bra	.\@
	endm
