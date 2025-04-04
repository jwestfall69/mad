	include "cpu/konami/include/dsub.inc"

	global print_xy_string
	global print_xy_string_list

	section code

; params:
;  y = address of XY_STRING struct
print_xy_string:
		lda	,y+
		ldb	,y+
		RSUB	screen_seek_xy
		RSUB	print_string
		rts

; params:
;  y = address of start of XY_STRING struct list
print_xy_string_list:
		lda	,y+
		cmpa	#$ff			; end of list marker
		beq	.list_end
		ldb	,y+
		RSUB	screen_seek_xy
		RSUB	print_string
		bra	print_xy_string_list

	.list_end:
		rts
