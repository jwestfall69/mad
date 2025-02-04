	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		; doing it like this so the same compiled rom
		; can be used to make a suicided rom or encrypted
		cmp.l	#(WORK_RAM_START + WORK_RAM_SIZE), $0
		beq	.suicide

		; unclear at this point if this might be required
		; to be different depending on romset or if we
		; could get away with them all being the same
		ROMSET_INIT
		bra	.init_done

	.suicide:
		SUICIDE_INIT

	.init_done:
		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y

		;SOUND_STOP

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		;RSUB_INIT
		moveq	#$1c, d7
		move.l	#SP_INIT_ADDR, sp

		bsr	auto_func_tests

		clr.b	r_menu_cursor
		bra	main_menu
