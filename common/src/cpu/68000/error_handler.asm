	include "cpu/68000/dsub.inc"
	include "cpu/68000/error_handler.inc"
	include "cpu/68000/print_error.inc"

	global error_handler_dsub

	section code
; based on the error code, figure out which print error
; function should be called and call it
; params:
;  d0 = error code
;  d1 = error data
;  d2 = error data
;  a0 = error data
; returns
;  a1 = error code description
;  a2 = print error dsub
;  d0-d2, a0 are unmodified
error_handler_dsub:

		; use the error code to find the correct print error dsub id
		lea	(EC_TABLE), a1
	.loop_ec_next_entry:
		cmp.b	(a1), d0
		beq	.ec_found
		addq.l	#6, a1
		tst.l	(a1)			; table is null terminated
		bne	.loop_ec_next_entry

		; failed to find error code !?
		move.b	#PRINT_ERROR_INVALID, d1
		lea	print_error_invalid_dsub, a2
		bra	.pf_run

	.ec_found:
		move.b  (1, a1), d4	; print error dsub id
		movea.l	(2, a1), a1	; error description string
		and.w	#$ff, d4

		; use the print error dsub id to find print error dsub to run
		lea	(EC_PRINT_TABLE), a2
	.loop_pf_next_entry:
		cmp.w	(a2), d4
		beq 	.pf_found
		addq.l	#6, a2
		tst.l	(a2)			; table is null terminated
		bne	.loop_pf_next_entry

		; no print function found !?
		lea	print_error_invalid_dsub, a2
		move.b	d4, d1
		bra	.pf_run

	.pf_found:
		movea.l	(2, a2), a2

	.pf_run:
		jmp	(a2)		; pf will DSUB_RETURN