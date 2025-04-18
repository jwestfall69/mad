	; dsub (in psub mode) allows 1 level of nesting
	; by making use of the u and s registers.  We
	; obviously need to be mindful of using the s
	; register, so we need to makes sure int's and
	; nmi's don't fire.  The latter can be disabled
	; on konami games that have them (only 2 it seems)

	; We are using the value of the s register to
	; determine if we are in PSUB or RSUB mode. If
	; the value is >= $e000 it means its pointing
	; at rom space, which implies we are in PSUB
	; mode.
	macro DSUB_MODE_PSUB
		ldu	#$fffe
		lds	#$fffe
	endm

	macro DSUB_MODE_RSUB
		lds	#(WORK_RAM_START + WORK_RAM_SIZE)
	endm

	; Based on what mode we are in do the right
	; thing to get to the function.  This macro
	; should only be used if a _dsub needs to call
	; another _dsub, where the outer _dsub could
	; be called in either mode
	macro DSUB
		cmps	#$c000
		blo	.\@do_jsr
		tfr	u, s
		ldu	#.\@psub_return
		jmp	\1_dsub
	.\@psub_return:
		tfr	s, u
		bra	.\@dsub_end

	.\@do_jsr:
		jsr	\1_dsub
	.\@dsub_end:
	endm

	macro DSUB_RETURN
		cmps	#$c000
		blo	.\@do_rts
		jmp	0, u
	.\@do_rts:
		rts
	endm

	macro RSUB
		jsr	\1_dsub
	endm

	macro PSUB
		tfr	u, s
		ldu	#.\@
		jmp	\1_dsub
	.\@:
		tfr	s, u
	endm

