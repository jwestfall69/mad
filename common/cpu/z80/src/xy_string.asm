	include "cpu/z80/include/dsub.inc"

	global print_xy_string
	global print_xy_string_list

	section code

; params
;  de = address of XY_STRING struct
print_xy_string:
		ld	a, (de)
		ld	b, a
		inc	de

		ld	a, (de)
		ld	c, a
		inc	de
		RSUB	screen_seek_xy
		RSUB	print_string
		ret

; params
;  de = address of XY_STRING struct list
print_xy_string_list:
		ld	a, (de)
		cp	$ff
		jr	z, .list_end

		ld	b, a
		inc	de

		ld	a, (de)
		ld	c, a
		inc	de
		RSUB	screen_seek_xy
		RSUB	print_string
		inc	de
		jr	print_xy_string_list
	.list_end:
		ret
