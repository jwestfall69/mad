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


	macro CPU_INTS_ENABLE
		andcc	#$af
	endm


	macro CPU_INTS_DISABLE
		orcc	#$50
	endm
