	global r_irq_count
	global r_firq_count
	global r_nmi_count

	section vectors

		dc.w	swi_handler
		dc.w	swi_handler
		dc.w	firq_handler
		dc.w	irq_handler
		dc.w	swi_handler
		dc.w	nmi_handler
		dc.w	_start

	section code

irq_handler:
		pshs	d
		ldd	r_irq_count
		incd
		std	r_irq_count
		puls	d
		rti

firq_handler:
		pshs	d
		lda	#$0
		sta	$2600

		ldd	r_firq_count
		incd
		std	r_firq_count

		lda	#$2
		sta	$2600
		puls	d
		rti

nmi_handler:
		pshs	d
		ldd	r_nmi_count
		incd
		std	r_nmi_count
		puls	d
		rti

swi_handler:
		rti

	section bss

r_irq_count:		dcb.w 1
r_firq_count:		dcb.w 1
r_nmi_count:		dcb.w 1
