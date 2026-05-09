	include "cpu/6309/include/common.inc"

	global _start

	section code

_start:
		ldd	#$0100
		sta	REG_CONTROL
		stb	$0007

		WATCHDOG

		ldd	#$0008
		std	$0000
		ldb	#$2c
		std	$0002
		ldd	#$c009
		std	$0004
		ldd	#$0902
		std	$0006

		; this sets it up so the top 5 tile
		; rows come from tile b of g15 k007121
		; mimicking contra
		ldx	#$0042
		lda	#$1
		ldb	#$5
	.loop_next_scroll_addr:
		sta	,x+
		decb
		bne	.loop_next_scroll_addr

		lda	#$41
		sta	REG_CONTROL
		ldd	#$0008
		std	$0000
		ldb	#$2c
		std	$0002
		ldd	#$c009
		std	$0004
		ldd	#$0900
		std	$0006

		stb	$040c

		lda	#$01
		sta	REG_CONTROL

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	auto_mad_rom_address_test
		PSUB	auto_mad_rom_crc32_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		jsr	auto_func_tests

		lda	#SOUND_NUM_SUCCESS
		SOUND_PLAY

		; this is needed to populate the initial
		; trackball x/y values
		jsr	input_update
		jsr	main_menu
