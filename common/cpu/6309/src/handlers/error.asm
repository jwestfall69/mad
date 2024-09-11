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
		sta	PE_DATA_A
		stb	PE_DATA_B
		ste	PE_DATA_E
		stx	PE_DATA_X

		; screen maybe messed up depending
		; on which test is running
		PSUB	screen_init

		lda	PE_DATA_A
		ldx	#EC_LIST
	.loop_ec_next_entry:
		cmpa	, x
		beq	.ec_found

		leax	4, x	; next entry
		tst	, x	; list is null terminated
		bne	.loop_ec_next_entry

		; failed to find error code !?
		lda	#PRINT_ERROR_INVALID
		sta	PE_DATA_B
		ldx	print_error_invalid
		bra	.pe_run

	.ec_found:
		lda	1, x	; print error function id
		ldy	2, x
		sty	PE_STRING_ADDR


		; use the print error dsub id to find print error function to run
		ldx	#EC_PRINT_LIST
	.loop_pe_next_entry:
		cmpa	, x
		beq	.pe_found
		leax	3, x	; next entry
		tst	, x	; list is null terminated
		bne	.loop_pe_next_entry

		; no print function found !?
		sta	PE_DATA_B
		ldx	print_error_invalid
		bra	.pe_run

	.pe_found:
		ldx	1, x	; print function address

	.pe_run:
		jsr	, x

		lda	PE_DATA_A
		PSUB	sound_play_byte

	ifnd _ERROR_ADDRESS_DISABLED_
		lda	PE_DATA_A
		STALL
		;jsr	error_address	; never returns
	else
		STALL
	endif
