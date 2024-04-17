	macro STRING
		dc.b \1, $0
		align 2
	endm

	macro STALL
.\@
		bra	.\@
	endm
