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

	ifd _INPUT_IO_
		ld	c, (ix + 1)
		in	a, (c)
	else
		ld	d, (ix + 2)
		ld	e, (ix + 1)
		ld	a, (de)
	endif

		xor	$ff
		ld	c, a
		RSUB	print_bits_byte

		ld	bc, 3
		add	ix, bc
		jr	print_input_list

	.list_end:
		ret
