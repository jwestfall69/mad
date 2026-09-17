	include "cpu/6809/include/common.inc"

	global r_firq_count
	global r_irq_count
	global r_nmi_count
	global r_reg_control_saved

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
		lda	#CTRL_FIRQ_ENABLE
		coma
		anda	r_reg_control_saved
		sta	>REG_CONTROL

		ldd	r_firq_count
		addd	#$1
		std	r_firq_count

		lda	r_reg_control_saved
		sta	>REG_CONTROL

		puls	d
		rti

irq_handler:
		lda	#CTRL_IRQ_ENABLE
		coma
		anda	r_reg_control_saved
		sta	>REG_CONTROL


		ldd	r_irq_count
		addd	#$1
		std	r_irq_count

		lda	r_reg_control_saved
		sta	>REG_CONTROL
		rti

nmi_handler:
		lda	#CTRL_NMI_ENABLE
		coma
		anda	r_reg_control_saved
		sta	>REG_CONTROL

		ldd	r_nmi_count
		addd	#$1
		std	r_nmi_count

		lda	r_reg_control_saved
		sta	>REG_CONTROL
		rti

swi_handler:
		rti

	section bss

r_firq_count:			dcb.w 1
r_irq_count:			dcb.w 1
r_nmi_count:			dcb.w 1
r_reg_control_saved:		dcb.b 1
