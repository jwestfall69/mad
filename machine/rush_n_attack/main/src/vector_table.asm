	include "cpu/z80/include/common.inc"

	global r_irq_count
	global r_nmi_count
	global r_reg_control_saved

	section vectors

	rorg RST_ENTRY
		jp	_start

	rorg RST_IRQ
		jp	irq_handler

	rorg RST_NMI
		jp	nmi_handler


	section code

; the 005849 custom can generate both IRQ and FIRQ interrupts,
; according to the schematics both of these are connected to the
; z80's IRQ pin via an AND gate.
irq_handler:
		di
		push	af
		push	hl

		ld	hl, r_reg_control_saved
		ld	a, CTRL_IRQ_ENABLE|CTRL_FIRQ_ENABLE
		cpl
		and	a, (hl)
		ld	(REG_CONTROL), a

		ld	hl, (r_irq_count)
		inc	hl
		ld	(r_irq_count), hl


		ld	a, (r_reg_control_saved)
		ld	(REG_CONTROL), a
		pop	hl
		pop	af
		ei
		reti

nmi_handler:
		push	af
		push	hl

		ld	hl, r_reg_control_saved
		ld	a, CTRL_NMI_ENABLE
		cpl
		and	a, (hl)
		ld	(REG_CONTROL), a

		ld	hl, (r_nmi_count)
		inc	hl
		ld	(r_nmi_count), hl


		ld	a, (r_reg_control_saved)
		ld	(REG_CONTROL), a
		pop	hl
		pop	af
		reti

	section bss

r_irq_count:		dcb.w 1
r_nmi_count:		dcb.w 1
r_reg_control_saved:	dcb.b 1
