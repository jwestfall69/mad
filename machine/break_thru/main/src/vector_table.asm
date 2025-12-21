	include "cpu/6809/include/common.inc"

	global r_irq_count
	global r_nmi_count
	global r_reg_control2_saved

	section vectors

		dc.w	swi_handler
		dc.w	swi_handler
		dc.w	firq_handler
		dc.w	irq_handler
		dc.w	swi_handler
		dc.w	nmi_handler
		dc.w	_start

	section code

nmi_handler:
		ldd	r_nmi_count
		addd	#$1
		std	r_nmi_count
		rti

irq_handler:
		ldd	r_irq_count
		addd	#$1
		std	r_irq_count

		lda	r_reg_control2_saved
		ora	#CTRL2_IRQ_DISABLE
		sta	REG_CONTROL2
		lda	r_reg_control2_saved
		sta	REG_CONTROL2
		rti

; firq is tied to vcc
firq_handler:
swi_handler:
		rti

	section bss

r_irq_count:			dcb.w 1
r_nmi_count:			dcb.w 1
r_reg_control2_saved:		dcb.b 1
