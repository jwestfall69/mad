	include "cpu/z80/include/common.inc"

	global sprite_ram_clear

	section code


; sprite ram can only be written during a vblank.  The irq line will
; likely already be low and have an unserviced irq.  This will mean
; the rst10_handler will instantly trigger and not be an actual vblank.
; So we need to wait for the rst10_handler call after that before we
; request a sprite ram clear
sprite_ram_clear:
		ld	bc, $0
		ld	(r_rst10_count), bc

		ei

	.wait_vblank:
		ld	bc, (r_rst10_count)
		ld	a, c
		cp	$0
		jr	z, .wait_vblank

		ld	a, $1 << SPRITE_REQ_CLEAR_BIT
		ld	(r_sprite_req), a

	.wait_clear:
		ld	a, (r_sprite_req)
		cp	$0
		jr	nz, .wait_clear

		di
		ret
