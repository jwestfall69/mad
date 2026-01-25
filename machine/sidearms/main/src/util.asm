	include "cpu/z80/include/common.inc"

	global palette_copy

	section code

; params
;  de = src address
;  hl = dst address
;   c = palette size
palette_copy:
		ld	(r_palette_copy_src), de
		ld	(r_palette_copy_dst), hl
		ld	a, c
		srl	a
		ld	(r_palette_copy_size), a

	.loop_write_failed:
		ld	hl, (r_palette_copy_src)
		ld	ix, (r_palette_copy_dst)
		ld	iy, (r_palette_copy_dst)
		ld	bc, $400
		add	iy, bc

		ld	a, (r_palette_copy_size)
		ld	b, a

		ld	(REG_PAL_WRITE_ERROR_CLEAR), a
	.loop_next_byte:
		ld	a, (hl)
		ld	(iy), a
		inc	hl
		ld	a, (hl)
		ld	(ix), a

		inc	ix
		inc	iy
		inc	hl
		dec	b
		jr	nz, .loop_next_byte

		ld	a, (REG_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_write_failed
		ret

	section bss

r_palette_copy_src:	dcb.w 1
r_palette_copy_dst:	dcb.w 1
r_palette_copy_size:	dcb.b 1
