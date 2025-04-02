	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/error_codes.inc"
	include "cpu/konami/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE
		lds	#(WORK_RAM_START + WORK_RAM_SIZE)

		lda	#$12
		sta	$7c00

		lda	#$80
		sta	$3f9c

		; hardware seems to ignore watchdog ping until this
		; instruction is called the first time
		setline	$80

		jsr	screen_init
		jsr	main_menu
