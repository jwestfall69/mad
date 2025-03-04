	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/print_error.inc"
	include "cpu/68000/include/handlers/error.inc"

	include "machine.inc"
	include "mad.inc"

	global error_handler_dsub

	section code
; based on the error code, figure out which print error
; function should be called and call it
; params:
;  d0 = error code
;  d1 = error data
;  d2 = error data
;  a0 = error data
error_handler_dsub:

		; The screen maybe in a screwed up state depending
		; on what test was running.  So backup the error
		; data then re-init the screen.
		move.l	d0, d3
		move.l	d1, d4
		move.l	d2, d5
		move.l	a0, d6
		DSUB 	screen_init
		move.l	d3, d0
		move.l	d4, d1
		move.l	d5, d2
		move.l	d6, a0

		; use the error code to find the correct print error dsub id
		lea	(d_ec_list), a1
	.loop_ec_next_entry:
		cmp.b	s_ee_error_code(a1), d0
		beq	.ec_found
		addq.l	#s_ee_struct_size, a1
		tst.l	(a1)			; table is null terminated
		bne	.loop_ec_next_entry

		; failed to find error code !?
		move.b	#PRINT_ERROR_INVALID, d1
		lea	print_error_invalid_dsub, a2
		bra	.pe_run

	.ec_found:
		move.b	s_ee_print_error_id(a1), d4
		movea.l	s_ee_description_ptr(a1), a1
		and.w	#$ff, d4

		; use the print error dsub id to find print error dsub to run
		lea	(d_ec_print_list), a2
	.loop_pe_next_entry:
		cmp.w	s_pe_print_error_id(a2), d4
		beq 	.pe_found
		addq.l	#s_pe_struct_size, a2
		tst.l	(a2)			; table is null terminated
		bne	.loop_pe_next_entry

		; no print function found !?
		lea	print_error_invalid_dsub, a2
		move.b	d4, d1
		bra	.pe_run

	.pe_found:
		movea.l	s_pe_function_ptr(a2), a2

	.pe_run:
		move.b	d0, d6		; backup error code

		; manually do dsub based on the print function,
		; which is already in a2
		lea	.pe_return, a3
		bra	dsub_enter

	.pe_return:
		move.b	d6, d0
		DSUB	sound_play_byte

	ifnd _ERROR_ADDRESS_DISABLED_
		; d6 will still contain the error code
		move.b	d6, d0
		jmp	error_address
	else
		STALL
	endif
