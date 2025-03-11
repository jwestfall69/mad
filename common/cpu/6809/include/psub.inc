	; no nesting is supported
	macro PSUB
		ldu	#.\@
		jmp	\1_psub
	.\@:
	endm

	macro PSUB_RETURN
		jmp	0, u
	endm
