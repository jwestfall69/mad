	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/print_error.inc"
	include "cpu/z80/include/handlers/error.inc"

	global error_handler

	section code

; based on the error code, figure out which print error
; function should be called and call it
; params:
;  a = error code
;  b = error data
;  c = error data
;  hl = error data
error_handler:
		ld	(r_pe_data_a), a
		ld	a, b
		ld	(r_pe_data_b), a
		ld	a, c
		ld	(r_pe_data_c), a
		ld	(r_pe_data_hl), hl

		; screen maybe messed up depending
		; on which test is running
		RSUB	screen_init

		ld	ix, d_ec_list
		ld	a, (r_pe_data_a)
		ld	e, a
	.loop_ec_next_entry:
		ld	a, e
		cp	(ix + s_ee_error_code)
		jr	z, .ec_found

		ld	bc, s_ee_struct_size
		add	ix, bc

		xor	a
		cp	(ix + s_ee_error_code)
		jr	nz, .loop_ec_next_entry

		; failed to find error code !?
		ld	a, PRINT_ERROR_INVALID
		ld	(r_pe_data_b), a
		ld	hl, print_error_invalid
		jr	.pe_run

	.ec_found:
		ld	l, (ix + s_ee_description_ptr)
		ld	h, (ix + s_ee_description_ptr + 1)
		ld	(r_pe_string_ptr), hl
		ld	e, (ix + s_ee_print_error_id)

		ld	iy, d_ec_print_list
	.loop_pe_next_entry:
		ld	a, e
		cp	(iy + s_pe_print_error_id)
		jr	z, .pe_found

		ld	bc, s_pe_struct_size
		add	iy, bc

		xor	a
		cp	(iy + s_pe_print_error_id)
		jr	nz, .loop_pe_next_entry

		; no print function found !?
		ld	a, e
		ld	(r_pe_data_b), a
		ld	hl, print_error_invalid
		jr	.pe_run

	.pe_found:
		ld	l, (iy + s_pe_function_ptr)
		ld	h, (iy + s_pe_function_ptr + 1)

	.pe_run:
		; setup stack so we ret to after the jp
		ld	de, .pe_return
		push	de
		jp	(hl)
	.pe_return:


	;	ld	a, (r_pe_data_a)
	;	RSUB	sound_play_byte

	ifnd _ERROR_ADDRESS_DISABLED_
		ld	a, (r_pe_data_a)
		jp	error_address
	else
		STALL
	endif

		STALL
