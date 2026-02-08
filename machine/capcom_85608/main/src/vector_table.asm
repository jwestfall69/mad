	include "cpu/z80/include/common.inc"

	global r_irq_count
	global r_nmi_count
	global r_nmi_copy_src
	global r_nmi_copy_dst
	global r_nmi_copy_size

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

		pop	hl
		pop	af

		ei
		ret

; vblank
nmi_handler:
		push	af
		push	hl

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

		ld	hl, (r_nmi_count)
		inc	hl
		ld	(r_nmi_count), hl

		; The hardware only likes it if palette ram is written to
		; during vblank.  Below is a memory copy routine that copies
		; r_nmi_copy_src to r_nmi_copy_dst if/for r_nmi_copy_size > 0
		ld	a, (r_nmi_copy_size)
		cp	$0
		jr	z, .skip_nmi_copy

		push	bc
		push	de

		ld	b, $0
		ld	c, a
		ld	hl, (r_nmi_copy_src)
		ld	de, (r_nmi_copy_dst)
		ldir

		pop	de
		pop	bc

		; zero out size to indicate we are done
		ld	a, $0
		ld	(r_nmi_copy_size), a

	.skip_nmi_copy:
		; this seems to only work within vblank
		ld	(REG_SPRITE_COPY_REQUEST), a
		nop
		nop
		nop
		nop

		ld	a, CTRL_RS_BASE|CTRL_NMI_ENABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a
		pop	hl
		pop	af
		retn


	section bss

r_irq_count:		dcb.w 1
r_nmi_count:		dcb.w 1
r_nmi_copy_src:		dcb.w 1
r_nmi_copy_dst:		dcb.w 1
r_nmi_copy_size:	dcb.b 1
