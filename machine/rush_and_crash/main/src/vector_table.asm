	include "cpu/6809/include/common.inc"

	global r_irq_count
	global r_firq_count
	global r_vblank_copy_src
	global r_vblank_copy_dst
	global r_vblank_copy_size
	global r_vblank_fill_addr
	global r_vblank_fill_data
	global r_vblank_fill_size

	section vectors

		dc.w	swi_handler
		dc.w	swi_handler
		dc.w	firq_handler
		dc.w	irq_handler
		dc.w	swi_handler
		dc.w	nmi_handler
		dc.w	_start

	section code

firq_handler:
		pshs	d
		ldd	r_firq_count
		addd	#$1
		std	r_firq_count
		puls	d
		rti

; vblank?
irq_handler:
		ldd	r_irq_count
		addd	#$1
		std	r_irq_count

		ldd	r_vblank_copy_size
		beq	.skip_vblank_copy
		ldx	r_vblank_copy_src
		ldy	r_vblank_copy_dst
		jsr	memory_copy
		ldd	#$0
		std	r_vblank_copy_size


	.skip_vblank_copy:
		ldy	r_vblank_fill_size
		beq	.skip_vblank_fill
		ldx	r_vblank_fill_addr
		lda	r_vblank_fill_data
		RSUB	memory_fill

		ldd	#$0
		std	r_vblank_fill_size

	.skip_vblank_fill:

		rti

nmi_handler:
swi_handler:
		rti

	section bss

r_irq_count:		dcb.w 1
r_firq_count:		dcb.w 1

r_vblank_copy_src:	dcb.w 1
r_vblank_copy_dst:	dcb.w 1
r_vblank_copy_size:	dcb.w 1
r_vblank_fill_addr:	dcb.w 1
r_vblank_fill_data:	dcb.b 1
r_vblank_fill_size:	dcb.w 1
