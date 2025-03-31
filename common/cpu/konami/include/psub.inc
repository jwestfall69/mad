	; u and s registers are dedicated to psub and
	; allow for 1 level of nesting.  Once work ram
	; is tested ok, PSUB's should not be used anymore.
	; Additionally NMI handler needs to jmp _start to
	; block further NMI's
	macro PSUB
		tfr	u, s
		ldu	#.\@
		jmp	\1_psub
	.\@:
		tfr	s, u
	endm

	macro PSUB_RETURN
		jmp	0, u
	endm
