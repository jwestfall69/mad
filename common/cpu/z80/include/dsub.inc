DSUB_MODE_PSEUDO	equ $0
DSUB_MODE_REAL		equ $1

	; a' will contain our DSUB mode
	macro DSUB_MODE_PSUB
		ld	a, r
		and	a, $7f
		ld	r, a
		ld	a, DSUB_MODE_PSEUDO
		ex	af, af'
	endm

	macro DSUB_MODE_RSUB
		ld	a, DSUB_MODE_REAL
		ex	af, af'
		ld	sp, WORK_RAM + WORK_RAM_SIZE
	endm

	macro DSUB_RETURN
		jp	dsub_return
	endm

	; vasm doesn't allow DSUB since its a build-in
	; opcode for 8085 cpu??, which I guess is part
	; of the z80 core.  This macro should get used
	; if a DSUB needs to call another DSUB. It will
	; take care of calling it correctly (psub vs rsub)
	; so I guess call it NSUB for nested dsub?
	macro NSUB
		ex	af, af'
		cp	DSUB_MODE_REAL
		jr	z, .\@rsub_call
		ex	af, af'
		exx
		ld	hl, \1_dsub
		ld	de, .\@_return
		jp	dsub_enter
.\@rsub_call:
		ex	af, af'
		call	\1_dsub+1	; +1 to skip exx in _dsub
.\@_return:
	endm

	macro RSUB
		call	\1_dsub+1	; +1 to skip exx in _dsub
	endm

	macro PSUB
		exx
		ld	hl, \1_dsub
		ld	de, .\@
		jp	dsub_enter
.\@:
	endm

