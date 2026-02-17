	; raw delay without using any function/dsub.
	macro DELAY
		move.l	\1, d0
	.\@:
		WATCHDOG
		cmp.l	#$1, d0
		cmp.l	#$1, d0
		cmp.l	#$1, d0
		cmp.l	#$1, d0
		cmp.l	#$1, d0
		cmp.l	#$1, d0
		subq.l	#$1, d0
		bne	.\@
	endm

	macro STALL
	.\@:
		WATCHDOG
	ifd _STALL_DELAY_
		move.l	#$1fff, d0
		DSUB	delay
	endif
		bra	.\@
	endm


	macro CPU_INTS_ENABLE
		move.w	#$2000, sr
	endm

	macro CPU_INTS_DISABLE
		move.w	#$2700, sr
	endm
