	macro STALL
	.\@:
		WATCHDOG
	ifd _STALL_DELAY_
		ldw	#$1fff
		PSUB	delay
	endif
		jmp	.\@
	endm


	macro INTS_ENABLE
		andcc	#$af
	endm


	macro INTS_DISABLE
		orcc	#$50
	endm
