	macro STALL
	.\@:
		WATCHDOG
	ifd _STALL_DELAY_
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
		cmpd	#$0
	endif
		jmp	.\@
	endm


	macro INTS_ENABLE
		andcc	#$af
	endm


	macro INTS_DISABLE
		orcc	#$50
	endm
