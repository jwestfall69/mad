	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/memory_fill.inc"
	include "cpu/68000/ssa3.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global cps_a_init_dsub
	global palette_init_dsub
	global screen_init_dsub
	global screen_clear_dsub
	global screen_seek_xy_dsub

	section code

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

screen_clear_dsub:
screen_init_dsub:
		lea	MEMORY_FILL_LIST, a0
		DSUB	memory_fill_list

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


; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1
		lsl.l	#7, d0
		lsl.l	#2, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN

	section data

MEMORY_FILL_LIST
	MEMORY_FILL_ENTRY SCROLL1_RAM_START, SCROLL1_RAM_SIZE / 2, $0
	MEMORY_FILL_ENTRY SCROLL2_RAM_START, SCROLL2_RAM_SIZE / 2, $0
	MEMORY_FILL_ENTRY SCROLL3_RAM_START, SCROLL3_RAM_SIZE / 2, $0
	MEMORY_FILL_ENTRY OBJECT_RAM_START, OBJECT_RAM_SIZE / 2, $0
	MEMORY_FILL_ENTRY ROW_SCROLL_RAM_START, ROW_SCROLL_RAM_SIZE / 2, $0
	MEMORY_FILL_ENTRY PALETTE_RAM_START, PALETTE_RAM_SIZE / 2, $f0f0
	MEMORY_FILL_ENTRY_LIST_END

STR_HEADER:	STRING "CPS1 DIAG 0.01 - ACK"

	section bss

P1_INPUT_EDGE:	dc.w $0
P1_INPUT_RAW:	dc.w $0
P2_INPUT_EDGE:	dc.w $0
P2_INPUT_RAW:	dc.w $0
