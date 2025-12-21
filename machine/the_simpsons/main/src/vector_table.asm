	include "cpu/konami2/include/common.inc"

	global r_irq_count
	global r_firq_count

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
		WATCHDOG

		lda	#$fb
		sta	$1d00

		ldd	r_irq_count
		addd	#$1
		std	r_irq_count

		lda	#$ff
		sta	$1d00
		rti

firq_handler:
		WATCHDOG

		pshs	d
		lda	#$0
		sta	$1fc2
		lda	#$24
		sta	$1fa5

		ldd	r_firq_count
		addd	#$1
		std	r_firq_count

		lda	#$34
		sta	$1fa5
		lda	#$4
		sta	$1fc2

		puls	d
		rti

nmi_handler:
swi_handler:
		rti

	section bss

r_irq_count:	dcb.w 1
r_firq_count:	dcb.w 1
