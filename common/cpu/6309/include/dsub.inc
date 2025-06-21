	; dsub (in psub mode) allows 1 level of nesting
	; by making use of the u and v registers.  

	; We are using the value of the s register to
	; determine if we are in PSUB or RSUB mode. If
	; the value is >= $c000 it means its pointing
	; at rom space, which implies we are in PSUB
	; mode.
	macro DSUB_MODE_PSUB
		ldu	#$fffe
	endm

	macro DSUB_MODE_RSUB
		ldu	#$0
		lds	#(WORK_RAM + WORK_RAM_SIZE - 2)
	endm

	; Based on what mode we are in do the right
	; thing to get to the function.  This macro
	; should only be used if a _dsub needs to call
	; another _dsub, where the outer _dsub could
	; be called in either mode
	macro DSUB
		cmpu	#$c000
		blo	.\@do_jsr
		tfr	u, v
		ldu	#.\@psub_return
		jmp	\1_dsub
	.\@psub_return:
		tfr	v, u
		bra	.\@dsub_end

	.\@do_jsr:
		jsr	\1_dsub
	.\@dsub_end:
	endm

	macro DSUB_RETURN
		cmpu	#$c000
		blo	.\@do_rts
		jmp	0, u
	.\@do_rts:
		rts
	endm

	macro RSUB
		jsr	\1_dsub
	endm

	macro PSUB
		tfr	u, v
		ldu	#.\@
		jmp	\1_dsub
	.\@:
		tfr	v, u
	endm

