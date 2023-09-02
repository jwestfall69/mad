	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/ssa3.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global cps_a_init_dsub
	global p1_input_update
	global palette_init_dsub
	global print_header_dsub
	global screen_init_dsub
	global screen_init2_dsub

	global P1_INPUT_EDGE
	global P1_INPUT_RAW
	global P2_INPUT_EDGE
	global P2_INPUT_RAW

	section code

p1_input_update:
		move.w	REG_P1_INPUT, d0
		not.w	d0
		move.w	P1_INPUT_RAW, d1
		eor.w	d0, d1
		and.w	d0, d1
		move.w	d1, P1_INPUT_EDGE
		move.w	d0, P1_INPUT_RAW
                rts

palette_init_dsub:

		ROMSET_PALETTE_SETUP

		move.w  #ROMSET_LAYER_CTRL, REGB_LAYER_CTRL
		move.w  #ROMSET_PALETTE_CTRL, REGB_PALETTE_CTRL
		move.w	#PALETTE_RAM_START / 256, REGA_PALETTE_RAM_BASE
		move.w  #ROMSET_VIDEO_CTRL, REGA_VIDEO_CONTROL
		DSUB_RETURN


screen_init2_dsub:
		lea	SCROLL1_RAM_START, a0
		move.w	#(SCROLL1_RAM_SIZE / 2), d0
		moveq	#$0, d1
		DSUB	memory_fill

		SEEK_XY	5, 0
		lea	STR_HEADER, a0
		DSUB	print_string

		SEEK_LN	1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat


		DSUB_RETURN

screen_init_dsub:
		lea	MEMORY_FILL_TABLE, a0
		DSUB	memory_fill_items

		SEEK_XY	5, 0
		lea	STR_HEADER, a0
		DSUB	print_string

		SEEK_LN	1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat

		DSUB	palette_init

		DSUB_RETURN


cps_a_init_dsub:
		move.w	#OBJECT_RAM_START / 256, REGA_OBJECT_RAM_BASE
		move.w	#SCROLL1_RAM_START / 256, REGA_SCROLL1_RAM_BASE
		move.w	#SCROLL2_RAM_START / 256, REGA_SCROLL2_RAM_BASE
		move.w	#SCROLL3_RAM_START / 256, REGA_SCROLL3_RAM_BASE
		move.w	#ROW_SCROLL_RAM_START / 256, REGA_ROW_SCROLL_RAM_BASE
		move.w	#(PALETTE_RAM_START / 256), REGA_PALETTE_RAM_BASE

		DSUB_RETURN


	section data

MEMORY_FILL_TABLE
	MEMORY_FILL_ITEM SCROLL1_RAM_START, SCROLL1_RAM_SIZE / 2, $0
	MEMORY_FILL_ITEM SCROLL2_RAM_START, SCROLL2_RAM_SIZE / 2, $0
	MEMORY_FILL_ITEM SCROLL3_RAM_START, SCROLL3_RAM_SIZE / 2, $0
	MEMORY_FILL_ITEM OBJECT_RAM_START, OBJECT_RAM_SIZE / 2, $0
	MEMORY_FILL_ITEM ROW_SCROLL_RAM_START, ROW_SCROLL_RAM_SIZE / 2, $0
	MEMORY_FILL_ITEM PALETTE_RAM_START, PALETTE_RAM_SIZE / 2, $f0f0
	MEMORY_FILL_ITEM_NULL

STR_HEADER:	STRING "CPS1 DIAG 0.01 - ACK"

	section bss

P1_INPUT_EDGE:	dc.w $0
P1_INPUT_RAW:	dc.w $0
P2_INPUT_EDGE:	dc.w $0
P2_INPUT_RAW:	dc.w $0
