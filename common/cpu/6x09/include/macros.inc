	; raw delay without using any function/dsub.
	macro DELAY
		ldd	\1
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
