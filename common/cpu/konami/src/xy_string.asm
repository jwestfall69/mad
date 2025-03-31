	global print_xy_string
	global print_xy_string_list

	section code

; params:
;  y = address of XY_STRING struct
print_xy_string:
		lda	,y+
		ldb	,y+
		jsr	screen_seek_xy
		jsr	print_string
		rts

; params:
;  y = address of start of XY_STRING struct list
print_xy_string_list:
		lda	,y+
		cmpa	#$ff			; end of list marker
		beq	.list_end
		ldb	,y+
		jsr	screen_seek_xy
		jsr	print_string
		bra	print_xy_string_list

	.list_end:
		rts
