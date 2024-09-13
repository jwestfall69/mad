	; struct xy_string {
	;   byte x, y;
	;   byte string[], $0
	; }
	macro XY_STRING
		dc.b	\1, \2
		dc.b	\3, $0
	endm

	macro XY_STRING_LIST_END
		dc.b	$ff
	endm
