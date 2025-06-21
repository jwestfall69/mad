	include "cpu/6309/include/dsub.inc"

	global print_xy_string_dsub
	global print_xy_string_list_dsub

	section code

; params:
;  y = address of XY_STRING struct
print_xy_string_dsub:
		lda	,y+
		ldb	,y+
		DSUB	screen_seek_xy
		DSUB	print_string
		DSUB_RETURN

; params:
;  y = address of start of XY_STRING struct list
print_xy_string_list_dsub:
		lda	,y+
		cmpa	#$ff			; end of list marker
		beq	.list_end
		ldb	,y+
		DSUB	screen_seek_xy
		DSUB	print_string
		bra	print_xy_string_list_dsub

	.list_end:
		DSUB_RETURN
