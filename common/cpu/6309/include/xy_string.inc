	; struct xy_string {
	;   byte x, y;
	;   byte string[], $0
	; }
	macro XY_STRING
		dfb	\1, \2
		dfb	\3, $0
	endm

	macro XY_STRING_LIST_END
		dfb	$ff
	endm
