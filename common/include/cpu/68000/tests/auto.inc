	macro AUTO_ENTRY
		dc.l	\1, \2
	endm

	macro AUTO_LIST_END
		dc.l	$0, $0
	endm
