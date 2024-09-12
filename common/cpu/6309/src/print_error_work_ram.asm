	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global print_error_work_ram_memory_psub

	section code

; This is a special print error memory function for
; work ram since we are only able to use registers
; during the tests and print errors.
; params:
;  b = actual value
;  e = expected value
;  x = failed address
print_error_work_ram_memory_psub:
		tfr	e, a
		tfr	d, y
		tfr	x, d

		SEEK_XY	12, 7
		PSUB	print_hex_word

		tfr	y, d
		SEEK_XY	14, 8
		PSUB	print_hex_byte

		tfr	y, d
		exg	a, b
		SEEK_XY	14, 9
		PSUB	print_hex_byte

		SEEK_XY	3,7
		ldy	#d_str_address
		PSUB	print_string

		SEEK_XY	3,8
		ldy	#d_str_expected
		PSUB	print_string

		SEEK_XY	3,9
		ldy	#d_str_actual
		PSUB	print_string
		PSUB_RETURN
