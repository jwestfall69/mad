	include "cpu/z80/include/common.inc"

	global r_rst08_count
	global r_rst10_count
	global r_sprite_data
	global r_sprite_req

	section vectors

	rorg RST_ENTRY
		jp	_start

	rorg $08
		jp	rst08_handler

	rorg $10
		jp	rst10_handler


	section code

; timer
rst08_handler:
		push	af
		push	hl

		ld	hl, (r_rst08_count)
		inc	hl
		ld	(r_rst08_count), hl

		pop	hl
		pop	af

		ei
		ret

; vblank
; sprite ram can only be written to during a vblank, so
; we have logic that can trigger a sprite ram clear and/or
; copy in our 4 byte sprite from sprite viewer/debug
rst10_handler:
		push	af
		push	hl

		ld	hl, (r_rst10_count)
		inc	hl
		ld	(r_rst10_count), hl

		ld	a, (r_sprite_req)
		bit	SPRITE_REQ_CLEAR_BIT, a
		jr	z, .skip_sprite_clear

		ld	a, SPRITE_RAM_SIZE
		ld	hl, SPRITE_RAM
	.loop_next_byte:
		ld	(hl), $0
		inc	hl
		dec	a
		jr	nz, .loop_next_byte

	.skip_sprite_clear:
		ld	a, (r_sprite_req)
		bit	SPRITE_REQ_COPY_BIT, a
		jr	z, .skip_sprite_copy

		ld	a, (r_sprite_data + 0)
		ld	(SPRITE_RAM + 0), a

		ld	a, (r_sprite_data + 1)
		ld	(SPRITE_RAM + 1), a

		ld	a, (r_sprite_data + 2)
		ld	(SPRITE_RAM + 2), a

		ld	a, (r_sprite_data + 3)
		ld	(SPRITE_RAM + 3), a

	.skip_sprite_copy:
		ld	a, $0
		ld	(r_sprite_req), a

		pop	hl
		pop	af
		ei
		ret

	section bss

r_sprite_data:		dcb.b 4
r_sprite_req:		dcb.b 1

r_rst08_count:		dcb.w 1
r_rst10_count:		dcb.w 1
