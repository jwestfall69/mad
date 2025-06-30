	include "cpu/z80/include/common.inc"

	global dsub_enter
	global dsub_return

	section code

; dsub_enter/dsub_return allows creating and using dynamic subroutines.
; There are 2 modes for calling dynamic subroutines.
;
;  psuedo mode:
;    In this mode jumping to and returning from a dsub isn't reliant
;    on the stack, and thus there is no dependency on ram.  In this
;    mode ix and iy are used to store the jump back locations. To switch
;    switch to this mode a' and the high bit of the r register must
;    be initialized with the PSUB_INIT macro before making the first
;    PSUB call.
;
;  real mode:
;    In this mode jumping to and returning from a dsub will mimic
;    a normal call/ret.  ix and iy are free to use in this mode. To
;    switch to this mode a' be initialized with the RSUB_INIT macro
;    before making the first RSUB call.
;
; Up to 1 nested dsub calls are supported.  When I dsub calls another
; dsub, the nested call with follow the same mode its already in.
;
; psub_enter requires 2 registers to be setup
;  de = return address
;  hl = psub being jumped to
; This should is all handled by using the PSUB <psub> macro.
;
; NOTE: the PSUB macro will do an exx before setting up the de and hl
; registers.  A dsub code blocks must run exx as their first instruction
; and must not touch ix or iy registers.
;
; Code blocks that are dsubs should have _dsub append onto their
; subroutine names.
;
; A couple macros are set to deal with calling/returning from dsubs
;  NSUB <subroutine>
;   This should used when a dsub needs to call another dsub.  This will
;   deal with properly calling the nested subroutine based on what mode
;   we are in.
;  PSUB <subrouting>
;   This is meant to be called when using dsub in pseudo mode.
;  RSUB <subroutine>
;   This is meant to be called when using dsub in real mode.  It bypasses
;   using dsub_enter and will instead directly call the <subroutine>_dsub
;  DSUB_RETURN
;   When in a dsub, DSUB_RETURN should be used to return from the subroutine

dsub_enter:
		; We are using the unused high bit of the 'r' register
		; to determine if we are nested or not
		ld	a, r
		add	a, $80
		ld	r, a
		jp	p, .nested_call
		ld	ix, $0000
		add	ix, de
		jp	(hl)

	.nested_call:
		ld	iy, $0000
		add	iy, de
		jp	(hl)

; At the end of a dsub the block of code it should call DSUB_RETURN. This
; will jump to the below code.  It looks at a' to determine what mode we are
; in.  If real mode do an ret, else look at the high bit of the r register
; to determine if our jump back address is in ix or iy.
dsub_return:
		; make sure we dont clobber a or flags
		ex	af, af'
		cp	DSUB_MODE_REAL
		jr	z, .rsub_exit
		ld	a, r
		add	a, $80
		ld	r, a
		jp	m, .nested_return
		ld	a, DSUB_MODE_PSEUDO
		ex	af, af'
		jp	(ix)

	.nested_return:
		ld	a, DSUB_MODE_PSEUDO
		ex	af, af'
		jp	(iy)

	.rsub_exit:
		ex	af, af'
		ret
