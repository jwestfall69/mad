	include "cpu/68000/dsub.inc"
	include "cpu/68000/error_handler.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/print_error.inc"

	include "machine.inc"
	include "diag_rom.inc"

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
		lea	(EC_LIST), a1
	.loop_ec_next_entry:
		cmp.b	(a1), d0
		beq	.ec_found
		addq.l	#6, a1
		tst.l	(a1)			; table is null terminated
		bne	.loop_ec_next_entry

		; failed to find error code !?
		move.b	#PRINT_ERROR_INVALID, d1
		lea	print_error_invalid_dsub, a2
		bra	.pe_run

	.ec_found:
		move.b	(1, a1), d4	; print error dsub id
		movea.l	(2, a1), a1	; error description string
		and.w	#$ff, d4

		; use the print error dsub id to find print error dsub to run
		lea	(EC_PRINT_LIST), a2
	.loop_pe_next_entry:
		cmp.w	(a2), d4
		beq 	.pe_found
		addq.l	#6, a2
		tst.l	(a2)			; table is null terminated
		bne	.loop_pe_next_entry

		; no print function found !?
		lea	print_error_invalid_dsub, a2
		move.b	d4, d1
		bra	.pe_run

	.pe_found:
		movea.l	(2, a2), a2

	.pe_run:
		move.b	d0, d6		; backup error code

		; manually do dsub based on the print function,
		; which is already in a2
		lea	.pe_return, a3
		bra	dsub_enter

	.pe_return:
		move.b	d6, d0
		bra	sound_play_byte_dsub	; will DSUB_RETURN for us
