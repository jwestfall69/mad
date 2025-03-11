	macro STALL
	.\@:
		jmp	.\@
	endm


	macro INTS_ENABLE
		andcc	#$af
	endm


	macro INTS_DISABLE
		orcc	#$50
	endm
