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
		push	af
		push	hl

		ld	hl, (r_irq_count)
		inc	hl
		ld	(r_irq_count), hl

		ld	a, (REG_INPUT_SYS)
		bit	SYS_VBLANK_BIT, a
		jp	z, .not_vblank

		; Doing this outside of vblank seems to have a high chance of
		; the 86S105 IC getting stuck doing sprite dma over and over.
		; This causes the CPU to be 100% stuck waiting for it to
		; finish
		ld	(REG_SPRITE_COPY_REQUEST), a
		nop
		nop
		nop

	.not_vblank:
		pop	hl
		pop	af

		ei
		ret

nmi_handler:
		jp	_start


	section bss

r_irq_count:	dcb.w 1
