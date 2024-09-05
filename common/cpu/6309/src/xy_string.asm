	include "cpu/6309/include/psub.inc"

	global print_xy_string_psub
	global print_xy_string_list_psub

	section code

; params:
;  y = address of XY_STRING struct
print_xy_string_psub:
		lda	,y+
		ldb	,y+
		PSUB	screen_seek_xy
		PSUB	print_string

		PSUB_RETURN

; params:
;  y = address of start of XY_STRING struct list
print_xy_string_list_psub:
		lda	,y+
		cmpa	#$ff			; end of list marker
		beq	.list_end
		ldb	,y+
		PSUB	screen_seek_xy
		PSUB	print_string
		bra	print_xy_string_list_psub

	.list_end:
		PSUB_RETURN
