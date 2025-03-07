	macro STALL
.\@
		WATCHDOG
	ifd _STALL_DELAY_
		move.l	#$1fff, d0
		DSUB	delay
	endif
		bra	.\@
	endm


	macro INTS_ENABLE
		move.w	#$2000, sr
	endm

	macro INTS_DISABLE
		move.w	#$2700, sr
	endm
