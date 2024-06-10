	macro PSUB
		exx
		ld	hl, \1_psub
		ld	de, .\@
		jp	psub_enter
.\@:
	endm

	macro PSUB_RETURN
		jp	psub_exit
	endm
