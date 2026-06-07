	include "cpu/z80/include/common.inc"

	global wait_sprite_copy_request

	section code

wait_sprite_copy_request:

		ld	bc, $0
		ld	(r_rst10_count), bc
		ld	a, $0
		ld	(r_sprite_copy_request), a

		ei

	.loop_wait_rst10:
		ld	a, (r_rst10_count)
		cp	$0
		jr	z, .loop_wait_rst10

	.loop_wait_sprite_copy_request:
		ld	a, (r_sprite_copy_request)
		cp	$0
		jr	nz, .loop_wait_sprite_copy_request

		di

		ret

