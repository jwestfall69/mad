	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		clra
		sta	$000f	; K007452
		sta	$00f0	; ?
		WATCHDOG
		sta	$7000	; bank switch
		sta	$0000	; K007121 #1 - scroll x
		sta	$0018	; coin counter
		sta	$00f3	; ?

		;lda	#$b6
		lda	#$be
		sta	$0003	; K007121 #1 - screen setup
		sta	$0063	; K007121 #2 - screen setup

		;lda	#$f1
		clra
		sta	$0004	; K007121 #1 - tile stuff?
		sta	$0064	; K007121 #2 - tile stuff?

		lda	#$e4
		sta	$0005	; K007121 #1 - tile stuff?
		sta	$0065	; K007121 #2 - tile stuff?
		sta	$00f9	; ?

		clra
		sta	$0006	; K007121 #1 - tile stuff??
		sta	$00fc	; ?

		lda	#$10
		sta	$0066	; K007121 #2 - tile stuff??
		sta	$0067	; K007121 #2 - nmi/irq/flip enable/disable
		sta	$00fd	; ?

		clra
		sta	$0000	; K007121 #1 - scroll x
		sta	$0001	; K007121 #1 - scroll x
		sta	$0002	; K007121 #1 - scroll y
		sta	$0060	; K007121 #2 - scroll x
		sta	$0061	; K007121 #2 - scroll x
		sta	$0062	; K007121 #2 - scroll y
		sta	$00f2	; ?
		sta	$00fa	; ?

		PSUB	screen_init
		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		lds	#(WORK_RAM + WORK_RAM_SIZE - 2)
		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		jsr	main_menu
