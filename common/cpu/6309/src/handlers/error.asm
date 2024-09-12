	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/print_error.inc"
	include "cpu/6309/include/handlers/error.inc"

	include "machine.inc"
	include "mad_rom.inc"

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
		cmpa	, x
		beq	.ec_found

		leax	4, x	; next entry
		tst	, x	; list is null terminated
		bne	.loop_ec_next_entry

		; failed to find error code !?
		ldx	#print_error_invalid
		ldb	#PRINT_ERROR_INVALID
		stb	r_pe_data_b
		bra	.pe_run

	.ec_found:
		lda	1, x	; print error function id
		ldy	2, x
		sty	r_pe_string_addr


		; use the print error dsub id to find print error function to run
		ldx	#d_ec_print_list
	.loop_pe_next_entry:
		cmpa	, x
		beq	.pe_found
		leax	3, x	; next entry
		tst	, x	; list is null terminated
		bne	.loop_pe_next_entry

		; no print function found !?
		sta	r_pe_data_b
		ldx	#print_error_invalid
		bra	.pe_run

	.pe_found:
		ldx	1, x	; print function address

	.pe_run:
		jsr	, x

		lda	r_pe_data_a
		PSUB	sound_play_byte

	ifnd _ERROR_ADDRESS_DISABLED_
		lda	r_pe_data_a
		STALL
		;jsr	error_address	; never returns
	else
		STALL
	endif
