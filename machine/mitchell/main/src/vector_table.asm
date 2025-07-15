	include "cpu/z80/include/common.inc"

	global r_irq_count

	section vectors

	rorg RST_ENTRY
		jp	_start

	rorg RST_IRQ
		jp	irq_handler

	rorg RST_NMI
		jp	nmi_handler


	section code

irq_handler:
		di
		push	af
		push	hl

		ld	hl, (r_irq_count)
		inc	hl
		ld	(r_irq_count), hl

		in	a, (IO_INPUT_SYS2)
		cpl
		and	SYS2_VBLANK
		jr	z, .not_vblank

		; if in vblank request a sprite copy.  There is some
		; timing weirdness trying to do this outside of the
		; irq handler.  Manually waiting for vblank and then
		; doing the copy request doesn't always trigger it.
		out	(IO_SPRITE_COPY_REQUEST), a

	.not_vblank:
		pop	hl
		pop	af
		ei
		ret

nmi_handler:
		jp	_start


	section bss

r_irq_count:	dcb.w 1
