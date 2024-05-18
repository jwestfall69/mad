	include "cpu/68000/include/dsub.inc"

	global print_xy_string_dsub
	global print_xy_string_list_dsub

	section code

; params:
;  a0 = address of XY_STRING struct
print_xy_string_dsub:
		move.b	(a0)+, d0
		and.l	#$ff, d0
		move.b	(a0)+, d1
		and.l	#$ff, d1
		DSUB	screen_seek_xy
		DSUB	print_string
		DSUB_RETURN

; params
;  a0 = address of start of XY_STRING struct list
print_xy_string_list_dsub:

		move.b	(a0)+, d0
		cmp.b	#$ff, d0
		beq	.list_end

		and.l	#$ff, d0
		move.b	(a0)+, d1
		and.l	#$ff, d1
		DSUB	screen_seek_xy
		DSUB	print_string
		bra	print_xy_string_list_dsub

	.list_end:
		DSUB_RETURN
