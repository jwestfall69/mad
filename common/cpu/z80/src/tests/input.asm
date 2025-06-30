	include "cpu/z80/include/common.inc"

	global print_input_list

	section code

; params:
;  ix = address of start of INPUT_ENTRY struct list
print_input_list:
		WATCHDOG
		ld	c, (ix + 0)		; y offset
		xor	a
		cp	c
		jr	z, .list_end

		ld	b, SCREEN_START_X + 5
		RSUB	screen_seek_xy

		ld	c, (ix + 1)		; io #
		in	a, (c)
		xor	$ff
		ld	c, a
		RSUB	print_bits_byte

		ld	bc, 2
		add	ix, bc
		jr	print_input_list

	.list_end:
		ret
