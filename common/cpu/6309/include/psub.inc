	; u and v registers are dedicated to psub and
	; allow for 1 level of nesting
	macro PSUB
		tfr	u, v
		ldu	#.\@
		jmp	\1_psub
	.\@:
		tfr	v, u
	endm

	macro PSUB_RETURN
		jmp	0, u
	endm
