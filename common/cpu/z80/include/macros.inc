	macro STRING
		dc.b \1, $0
	endm

	macro STALL
.\@
		jp .\@
	endm
