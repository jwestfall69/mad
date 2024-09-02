	macro	STALL
	.\@:
		WATCHDOG
	ifd _STALL_DELAY_
		ldw	#$1fff
		PSUB	delay
	endif
		jmp	.\@
	endm
