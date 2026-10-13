	include "cpu/z80/include/common.inc"

	global bg_tile_ram_bank_test

	section code

bg_tile_ram_bank_test:
		call	print_b2_return_to_menu

		ld	b, $4		; # of banks
		ld	d, $0		; bank #
		ld	a, $1		; value to write
		ld	hl, BG_TILE_RAM
		ld	c, IO_BG_RAM_BANK

	.loop_next_write:
		out	(c), d
		ld	(hl), a
		inc	a
		inc	d
		djnz	.loop_next_write

		ld	b, $4
		ld	a, $1
		ld	d, $0
	.loop_next_read:
		out	(c), d
		cp	(hl)
		jr	nz, .test_failed
		inc	a
		inc	d
		djnz	.loop_next_read

		SEEK_XY	SCREEN_START_X, 10
		ld	de, d_str_test_passed
		RSUB	print_string
		jr	.exit

	.test_failed:
		ld	(r_pe_data_b), a
		ld	a, (hl)
		ld	(r_pe_data_c), a
		ld	hl, d_str_test_failed
		ld	(r_pe_string_ptr), hl
		call	print_error_hex_byte

	.exit:
		ld	b, INPUT_B2
		call	wait_button_press
		ret

	section data

d_str_test_passed:	STRING "TEST PASSED"
d_str_test_failed:	STRING "BG TILE RAM BANK TEST FAILED"
