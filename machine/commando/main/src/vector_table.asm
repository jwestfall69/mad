	include "cpu/z80/include/common.inc"

	global r_rst08_count
	global r_rst10_count
	global r_sprite_copy_request

	section vectors

	rorg RST_ENTRY
		; These 2 instructions come from the game and are not related
		; to anything mad is doing.  Without them the board will not
		; boot, even just changing $04 to $00 will prevent the board
		; from booting.  I'm a bit suspect they might have to do with
		; how the rom gets decoded as 4 happens to be the shift amount
		; of the encoding.
		; https://github.com/mamedev/mame/blob/fca00cace9e40ca70d82bbcc6dbd82167325e12b/src/mame/capcom/commando.cpp#L1025
		ld	a, $04
		ld	($e000), a

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
rst10_handler:
		push	af
		push	hl

		ld	hl, (r_rst10_count)
		inc	hl
		ld	(r_rst10_count), hl

		ld	a, (r_sprite_copy_request)
		cp	$0
		jr	z, .skip_sprite_copy_request
		ld	(REG_SPRITE_COPY_REQUEST), a
		ld	a, $0
		ld	(r_sprite_copy_request), a

	.skip_sprite_copy_request:
		pop	hl
		pop	af
		ei

		ret

	section bss

r_rst08_count:		dcb.w 1
r_rst10_count:		dcb.w 1

r_sprite_copy_request:	dcb.b 1
