	global dsub_enter
	global dsub_return

	section code

; dsub_enter/dsub_return allows creating and using dynamic subroutines.
; There are 2 modes for calling dynamic subroutines.
;
;  psuedo mode:
;    In this mode jumping to and returning from a dsub isn't reliant
;    on the stack, and thus there is no dependency on ram.  In this
;    mode a3, a4, a5, a7 are used to store the jump back locations. To
;    switch to this mode d7 must be initialized with the PSUB_INIT macro
;    before making the first psub call.
;
;  real mode:
;    In this mode jumping to and returning from a dsub will mimic
;    a normal bsr/rts by pushing the return address onto the stack.
;    a4, a5 are free to use outside the dsub. To swith to this mode
;    d7 must be initialized with the RSUB_INIT macro before making
;    the first rsub call.
;
; Up to 3 nested dsub calls are supported.  When I dsub calls another
; dsub, the nested call with follow the same mode its already in.
;
; dsub_enter requires 2 registers to be setup
; a2 = dsub that will be called
; a3 = address to jmp to when dsub is finished
;
; dsub code blocks should not touch a3/a4/a5/a7/d7 registers and/or use
; the stack. When a dsub code block is done it should jmp/bra to
; dsub_return instead of calling rts or something else.  a3 is the last
; used register when nesting.  It should be ok to use a3 register in a
; dsub call so long as you know you aren't fully nested.
;
; Code blocks that are dsubs should have _dsub append onto their
; subroutine names.
;
; A couple macros are set to deal with calling/returning from dsubs
;  DSUB <subroutine>
;   This will deal with setting the return label, populating a2, a3
;   and then jumping dsub_enter.  Note that the macro will automatically
;   append _dsub onto the supplied subroutine name.  This macro should be used
;   when a dsub calling another dsub
;  PSUB <subrouting>
;   This is meant to be called when using dsub in pseudo mode.  Its the exact
;   same as the DSUB macro.  It just exists to make it easier to follow the
;   code, by making it clear the call is meant to be pseudo.
;  RSUB <subroutine>
;   This is meant to be called when using dsub in real mode.  It bypasses
;   using dsub_enter and will instead directly adjust d7 then do an actual
;   bsr to the dsub.  Note that the macro will automatically append
;   _dsub onto the supplied subroutine name.
;  DSUB_RETURN
;   When in a dsub, DSUB_RETURN should be used to return from the subroutine
dsub_enter:
		subq.w	#4, d7
		jmp	*+4(PC, d7.w)

		; pseudo mode (PSUB)
		movea.l	a3, a3
		jmp	(a2)
		movea.l	a3, a4
		jmp	(a2)
		movea.l	a3, a5
		jmp	(a2)
		movea.l	a3, a7
		jmp	(a2)

		; real mode (RSUB)
		move.l	a3, -(a7)
		jmp	(a2)
		move.l	a3, -(a7)
		jmp	(a2)
		move.l	a3, -(a7)
		jmp	(a2)
		move.l	a3, -(a7)
		jmp	(a2)

dsub_return:
		addq.w	#4, d7
		jmp	*(PC, d7.w)

		; pseudo mode (PSUB)
		jmp	(a3)
		nop
		jmp	(a4)
		nop
		jmp	(a5)
		nop
		jmp	(a7)

		; real mode (RSUB)
		nop
		rts
		nop
		rts
		nop
		rts
		nop
		rts
