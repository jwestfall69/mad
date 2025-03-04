	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/print_error.inc"
	include "cpu/6309/include/handlers/error.inc"

	include "machine.inc"
	include "mad.inc"

	global error_handler

	section code

; based on the error code, figure out which print error
; function should be called and call it
; params:
;  a = error code
;  b = error data
;  e = error data
;  x = error data
error_handler:
		sta	r_pe_data_a
		stb	r_pe_data_b
		ste	r_pe_data_e
		stx	r_pe_data_x

		; screen maybe messed up depending
		; on which test is running
		PSUB	screen_init

		lda	r_pe_data_a
		ldx	#d_ec_list
	.loop_ec_next_entry:
		cmpa	s_ee_error_code, x
		beq	.ec_found

		leax	s_ee_struct_size, x	; next entry
		tst	s_ee_error_code, x	; list is null terminated
		bne	.loop_ec_next_entry

		; failed to find error code !?
		ldx	#print_error_invalid
		ldb	#PRINT_ERROR_INVALID
		stb	r_pe_data_b
		bra	.pe_run

	.ec_found:
		lda	s_ee_print_error_id, x
		ldy	s_ee_description_ptr, x
		sty	r_pe_string_ptr


		; use the print error dsub id to find print error function to run
		ldx	#d_ec_print_list
	.loop_pe_next_entry:
		cmpa	s_pe_print_error_id, x
		beq	.pe_found
		leax	s_pe_struct_size, x	; next entry
		tst	s_pe_print_error_id, x	; list is null terminated
		bne	.loop_pe_next_entry

		; no print function found !?
		sta	r_pe_data_b
		ldx	#print_error_invalid
		bra	.pe_run

	.pe_found:
		ldx	s_pe_function_ptr, x

	.pe_run:
		jsr	, x

		lda	r_pe_data_a
		PSUB	sound_play_byte

	ifnd _ERROR_ADDRESS_DISABLED_
		lda	r_pe_data_a
		jmp	error_address
	else
		STALL
	endif
